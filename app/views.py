from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth.hashers import make_password, check_password
from .models import Customer, Product, Staff, Sale, Delivery
from django.views import View
from datetime import datetime
from django.shortcuts import get_object_or_404
from django import template
register = template.Library()
from django.core.mail import send_mail
#from datetime import date

# Create your views here.
class Index:
    def __init__(self, request):
        self.request = request

    def index(request): # type:ignore
        stocks = Product.objects.all().order_by("-product_id")
        pureWaterStock = None
        bottleWaterStock = None
        pureWaterPrice = None
        bottleWaterPrice = None

        for stock in stocks:
            if stock.product_name == 'Polyunwana Pure Water':
                pureWaterStock = stock.stock_quantity
                pureWaterPrice = stock.product_price
            elif stock.product_name == 'Polyunwana Bottle Water':
                bottleWaterStock = stock.stock_quantity
                bottleWaterPrice = stock.product_price
        if request.method == "POST": #type:ignore
            email = request.POST.get('email')#type:ignore
            password = request.POST.get('password')#type:ignore
            if not email or not password:
                messages.error(request, "Please fill in all fields.") #type:ignore
                return redirect("index")

            try:
                customer = Customer.objects.get(customer_email=email)
                if check_password(password, customer.password):
                    request.session['email'] = customer.customer_email #type:ignore
                    return redirect('customer')

                else:
                    messages.error(request, "Incorrect email or password.") #type:ignore
                    return redirect("index")
            except Customer.DoesNotExist:
                messages.error(request, "Invalid email or password.") #type:ignore
                return redirect("index")
            
        context = {
            'watersum': pureWaterStock,
            'bottle': bottleWaterStock,
            'pure_water_price': pureWaterPrice,
            'bottle_water_price': bottleWaterPrice
        } 
        return render(request, "index.html", context) # type:ignore

class CustomerSignup:
    def __init__(self, request):
        self.request = request
    
    def signup(request): # type:ignore
        if request.method == "POST": # type:ignore
            firstname = request.POST.get('firstname') # type:ignore 
            lastname = request.POST.get('lastname') # type:ignore
            email = request.POST.get('email') # type:ignore
            phone = request.POST.get('phone') # type:ignore
            address = request.POST.get('address') # type:ignore
            pwd1 = request.POST.get('password1') # type:ignore
            pwd2 = request.POST.get('password2') # type:ignore

            if not firstname or not lastname or not email or not phone or not address or not pwd1 or not pwd2:
                messages.error(request, "All fields are required!") # type:ignore
                return redirect("signup")
            elif pwd1 != pwd2:
                messages.error(request, "Passwords do not match!") # type:ignore
                return redirect("signup")
            else:
                # Hash the password and save the user
                hashed_pwd = make_password(pwd1)
                # Save user logic here
                customer = Customer(
                    customer_name=f"{firstname} {lastname}",
                    customer_email=email,
                    customer_phone=phone,
                    customer_address=address,
                    password=hashed_pwd
                )
                
                customer.save()
                messages.success(request, "Account created successfully!") # type:ignore
                return redirect("index")

        return render(request, "signup.html") # type:ignore
    
    
    
class CreateStaff:
    def __init__(self, request):
        self.request = request
    
    def create_staff(request): #type:ignore
        if request.method == "POST": # type:ignore
            firstname = request.POST.get('firstname') # type:ignore 
            lastname = request.POST.get('lastname') # type:ignore
            email = request.POST.get('email') # type:ignore
            phone = request.POST.get('phone') # type:ignore
            role = request.POST.get('role') # type:ignore
            pwd1 = request.POST.get('password1') # type:ignore
            pwd2 = request.POST.get('password2') # type:ignore

            if not firstname or not lastname or not email or not phone or not role or not pwd1 or not pwd2:
                messages.error(request, "All fields are required!") # type:ignore
                return redirect("create_staff")
            elif pwd1 != pwd2:
                messages.error(request, "Passwords do not match!") # type:ignore
                return redirect("create_staff")
            else:
                # Hash the password and save the user
                hashed_pwd = make_password(pwd1)
                # Save user logic here
                staff = Staff(
                    staff_name=f"{firstname} {lastname}",
                    staff_email=email,
                    staff_phone=phone,
                    staff_role=role,
                    password=hashed_pwd
                )
                
                staff.save()
                messages.success(request, "Staff Account created successfully!") # type:ignore
                return redirect("login_staff")
        return render(request, "create_staff.html") #type:ignore
    
    def login_staff(request):#type:ignore
        if request.method == "POST": #type:ignore
            email = request.POST.get("email") #type:ignore
            password = request.POST.get("password") #type:ignore

            if not email or not password:
                messages.error(request, "Please fill in all fields.") #type:ignore
                return redirect("login_staff")

            try:
                staff = Staff.objects.get(staff_email=email)
                if check_password(password, staff.password):
                    request.session['email'] = staff.staff_email #type:ignore
                    if staff.staff_role == "Manager":
                        return redirect('manager')
                    
                    else:
                        return redirect('salesperson')

                else:
                    messages.error(request, "Incorrect email or password.") #type:ignore
                    return redirect("login_staff")
            except Staff.DoesNotExist:
                messages.error(request, "Invalid email or password.") #type:ignore
                return redirect("login_staff")
        return render(request, "login_staff.html") #type:ignore
        

class CustomerDashboard(View):
    def get(self, request): #type:ignore
        email = request.session.get('email') #type:ignore
        if not email:
            return redirect('index')
        user = Customer.objects.get(customer_email = email)
        orders = Sale.objects.filter(customer = user).order_by('-sale_id')
        deliveries = {d.sales.pk: d for d in Delivery.objects.filter(sales_id__in=orders)} 
        # deliveries = {d.sales_id: d for d in Delivery.objects.filter(sales_id__in=orders)}
        context = {
            'user':user,
            'orders':orders,
            'delivery':deliveries
        }
        return render(request, "customer/dashboard.html", context) #type:ignore
  
    def post(self, request):
        email = request.session.get('email') #type:ignore
        user = Customer.objects.get(customer_email = email)
        order_id = request.POST.get('delivered')
        
        if order_id:
            order = get_object_or_404(Sale, pk=order_id, customer=user)
            delivery, created = Delivery.objects.get_or_create(
                sales=order,
                defaults={
                    'delivery_date': datetime.now().date(),
                    'delivery_status': "Delivered"
                }
            )
            if not created:
                delivery.delivery_status = "Delivered"
                delivery.delivery_date = datetime.now().date()
                delivery.save()
        
        orders = Sale.objects.filter(customer=user).order_by('-sale_id')
        deliveries = {d.sales.pk: d for d in Delivery.objects.filter(sales_id__in=orders)}
        context = {
            'user': user,
            'orders': orders,
            'deliveries': deliveries
        }    

        return render(request, "customer/dashboard.html", context)

    
class CustomerMakeOrders(View):
    def get(self, request): #type:ignore
        stocks = Product.objects.all().order_by("-product_id")
        pureWaterStock = None
        bottleWaterStock = None
        pureWaterPrice = None
        bottleWaterPrice = None

        for stock in stocks:
            if stock.product_name == 'Polyunwana Pure Water':
                pureWaterStock = stock.stock_quantity
                pureWaterPrice = stock.product_price
            elif stock.product_name == 'Polyunwana Bottle Water':
                bottleWaterStock = stock.stock_quantity
                bottleWaterPrice = stock.product_price

        context = {
            'watersum': pureWaterStock,
            'bottle': bottleWaterStock,
            'pure_water_price': pureWaterPrice,
            'bottle_water_price': bottleWaterPrice
        }
        return render(request, "customer/orders.html", context)

    def post(self, request):
        email = request.session.get('email') #type:ignore
        user = Customer.objects.get(customer_email=email)

        if request.method == "POST":
            product_name = request.POST.get('name')
            quantity = request.POST.get('quantity')
            card_number = request.POST.get('card_number')
            card_name = request.POST.get('card_name')
            expiry = request.POST.get('expiry')
            cvv = request.POST.get('cvv')
            delevery_address = request.POST.get('delivery_address')
            if not product_name or not quantity or not card_number or not card_name or not expiry or not cvv or not delevery_address:
                messages.error(request, "All information is mandatory")
                return redirect('orders')
            elif len(card_number) < 16:
                messages.error(request, "Card number must be 16 digits")
                return redirect('orders')
            elif not card_number.isdigit():
                messages.error(request, "Card number must contain only digits")
                return redirect('orders')
            elif card_name.isdigit():
                messages.error(request, "Invalid card name")
                return redirect('orders')
            elif not quantity.isdigit():
                messages.error(request, "Incorrect value for Quantity")
                return redirect('orders')
            else:
                current_date = datetime.now().date()
                formated_date = current_date.strftime("%d/%m/%Y")
                user = Customer.objects.get(customer_email=email)

                try:
                    product = Product.objects.get(product_name=product_name)
                except Product.DoesNotExist:
                    messages.error(request, "Selected product does not exist")
                    return redirect('orders')
                order = Sale( #type:ignore
                    customer = user,
                    product = product, #type:ignore
                    sale_date = formated_date,
                    quantity_sold = quantity,
                    total_amount = float(product.product_price) * int(quantity),
                    payment_status = "Paid",
                    delivery_address = delevery_address
                    )
                new_stock = product.stock_quantity - int(quantity) #type:ignore
                product.stock_quantity = new_stock #type:ignore
                product.save()       
                order.save()
                try:
                    subject = f"Your {product.product_name} Order Confirmation"
                    message = f"Dear {user.customer_name}, this email confirms that you have successfully placed an order for {product.product_name} on {formated_date}. Thanks for your patronage."
                    from_email = 'paulekung@yahoo.com'
                    recipient_list = [user.customer_email]
                    send_mail(subject, message, from_email, recipient_list)
                except Exception:
                    pass
                    return redirect("customer")
                return redirect('customer')

        return render(request, "customer/orders.html")

class CustomerUpdateProfile(View):
    def get(self, request, customer_id):
        user = Customer.objects.get(customer_id = customer_id)
        name = user.customer_name
        first = name.split(" ")[0]
        second = name.split(" ")[1:][0]
        context = {'user':user, 'first':first, 'second':second}
        return render(request, "customer/update_profile.html", context)
    
    def post(self, request, customer_id):
        customer = Customer.objects.get(customer_id = customer_id)
        if request.method == "POST":
            firstname = request.POST.get('firstname')
            lastname = request.POST.get('lastname')
            email = request.POST.get('email')
            address = request.POST.get('address')
            phone = request.POST.get('phone')
            if not firstname or not lastname or not email or not address or not phone:
                messages.error(request, "Invalid form submission")
                return redirect('update_profile')
            else:
                customer.customer_name = f"{firstname} {lastname}" 
                customer.customer_email = email
                customer.customer_address = address
                customer.customer_phone = phone
                customer.save()
                return redirect('index')
            
        return render(request, "customer/update_profile.html")


class StaffDashboard:
    def __init__(self, request):
        self.request = request

    def manager_dashboard(request): #type:ignore
        user = request.session.get('email') #type:ignore
        if not user:
            return redirect('login_staff')
        manager = Staff.objects.get(staff_email=user)
        customers = Customer.objects.all().order_by('-customer_id')
        stocks = Product.objects.all().order_by('-product_id')
        staffs = Staff.objects.all().order_by('-staff_id')
        orders = Sale.objects.all().order_by('-sale_id')
        # Get deliveries for each order
        deliveries = {order.sale_id: Delivery.objects.filter(sales=order) for order in orders}
        # Equivalent using a normal for loop:
        #deliveries = {}
        #for order in orders:
            #deliveries[order.sale_id] = Delivery.objects.filter(sales=order)
        context = {
            'customers':customers,
            'stocks':stocks,
            'staffs':staffs,
            'orders':orders,
            'delivery':deliveries,
            'manager':manager
        }
        
        return render(request, "manager/dashboard.html", context) #type:ignore
    
    def add_stock(request): # type:ignore
            if request.method == "POST": #type:ignore
                name = request.POST.get("name") #type:ignore
                price = request.POST.get("price") #type:ignore
                quantity = request.POST.get("quantity") #type:ignore

                if not name or not price or not quantity:
                    messages.error(request, "All fields required.") #type:ignore
                    return redirect("add_stock")
                else:
                    stock = Product(
                        product_name = name,
                        product_price = price,
                        stock_quantity = quantity
                    )
                    stock.save()
                    messages.success(request, "Stock data updated successfully.") #type:ignore
                    return redirect("add_stock")
                    
            
            return render(request, "manager/add_stock.html")# type:ignore
    
    @staticmethod
    def update_stock(request, stock_id):#type:ignore
        stock = Product.objects.get(product_id = stock_id)
        if request.method == "POST":
            new_price = request.POST.get('new_price')
            new_quantity = request.POST.get('new_quantity')
            if new_price or new_quantity:
                stock.product_price = new_price
                stock.stock_quantity = new_quantity
                stock.save()
                messages.success(request, "Data updates successfully.")
            
        context = {'stock':stock}
        return render(request, "manager/update_stock.html", context) #type:ignore

class SalesPerson(View):
    def get(self, request):
        user = request.session.get('email')
        salesman = Staff.objects.get(staff_email = user)
        customers = Customer.objects.all().order_by('-customer_id')
        stocks = Product.objects.all().order_by('-product_id')
        orders = Sale.objects.all().order_by('-sale_id')
        context = {
            'salesman':salesman,
            'customers':customers,
            'stocks':stocks,
            'orders':orders

            }
        return render(request, "salesperson/dashboard.html", context)


class SalesPersonUpdateProfile(View):
    def get(self, request, staff_id):
        user = Staff.objects.get(staff_id = staff_id)
        name = user.staff_name
        name_parts = name.split(" ")
        first = name_parts[0]
        # Get the second or third name if available, else empty string
        second = name_parts[1] if len(name_parts) > 1 else (name_parts[2] if len(name_parts) > 2 else "")
        
        context = {'user':user, 'first':first, 'second':second}
        return render(request, "salesperson/update_staff_profile.html", context)
    
    def post(self, request, staff_id):
        staff = Staff.objects.get(staff_id=staff_id)
        if request.method == "POST":
            firstname = request.POST.get('firstname')
            lastname = request.POST.get('lastname')
            email = request.POST.get('email')
            role = request.POST.get('role')
            phone = request.POST.get('phone')
            if not firstname or not lastname or not email or not role or not phone:
                messages.error(request, "Invalid form submission")
                return redirect('update_salesperson_profile')
            else:
                staff.staff_name = f"{firstname} {lastname}" 
                staff.staff_email = email
                staff.staff_role = role
                staff.staff_phone = phone
                staff.save()
                return redirect('login_staff')
            
        return render(request, "salesperson/update_staff_profile.html")

class ConfirmDelivery(View):
    def get(self, request, sale_id):
        order = Sale.objects.get(sale_id=sale_id)
        context={'order':order}
        return render(request, "salesperson/confirm_delivery.html", context)
    
    def post(self, request, sale_id):
        order = Sale.objects.get(sale_id=sale_id)
        if request.method == "POST":
            confirmation = request.POST.get('confirmed')
            order.delivery_status = "Delivered"
            order.save()
            return redirect('salesperson')
        return render(request, "salesperson/confirm_delivery.html")

class GenerateReport(View):
    def post(self, request):
        report_type = request.POST.get('report_type')  # 'monthly' or 'annual'
        month = request.POST.get('report_month')  # e.g., '01', '02', ..., '12'
        year = request.POST.get('report_year')    # e.g., '2025'

        sales = Sale.objects.all()

        if report_type == 'monthly' and month and year:
            # Assuming sale_date is stored as string "dd/mm/YYYY"
            sales = Sale.objects.filter(
            sale_date__year=year,
            sale_date__month=month
            )
        elif report_type == 'annual' and year:
            sales = Sale.objects.filter(
                sale_date__year=year
            )

        total_sales = len(sales)
        total_amount = sum(float(s.total_amount) for s in sales)
        total_quantity = sum(int(s.quantity_sold) for s in sales)

        context = {
            'total_sales': total_sales,
            'total_amount': total_amount,
            'total_quantity': total_quantity,
            'sales': sales,
            'report_type': report_type,
            'month': month,
            'year': year
        }

        return render(request, "salesperson/report.html", context)

class ManagerUpdateProfile(View):
    def get(self, request, staff_id):
        user = Staff.objects.get(staff_id = staff_id)
        name = user.staff_name
        first = name.split(" ")[0]
        second = name.split(" ")[1:][0]
        context = {'user':user, 'first':first, 'second':second}
        return render(request, "manager/update_manager_profile.html", context)
    
    def post(self, request, staff_id):
        staff = Staff.objects.get(staff_id=staff_id)
        if request.method == "POST":
            firstname = request.POST.get('firstname')
            lastname = request.POST.get('lastname')
            email = request.POST.get('email')
            role = request.POST.get('role')
            phone = request.POST.get('phone')
            if not firstname or not lastname or not email or not role or not phone:
                messages.error(request, "Invalid form submission")
                return redirect('update_manager_profile')
            else:
                staff.staff_name = f"{firstname} {lastname}" 
                staff.staff_email = email
                staff.staff_role = role
                staff.staff_phone = phone
                staff.save()
                return redirect('login_staff')
            
        return render(request, "manager/update_manager_profile.html")
