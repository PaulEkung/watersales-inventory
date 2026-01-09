from django.db import models
from django.core.validators import EmailValidator
# Create your models here.
"""
The Customer class represents the intended users to be satisfied.
"""
class Customer(models.Model):
    customer_id = models.AutoField(primary_key=True)
    customer_name = models.CharField(max_length=50)
    customer_email = models.EmailField(max_length=50, unique=True, validators=[EmailValidator()])
    customer_phone = models.CharField(max_length=15, unique=True)
    customer_address = models.CharField(max_length=100)
    password = models.CharField(max_length=100, default="password")  # Store hashed password
    # returning at least one object
    def __str__(self) -> str:
        return self.customer_name
    
"""Product class: To store product"""
class Product(models.Model):
    product_id = models.AutoField(primary_key=True)
    product_name = models.CharField(max_length=40)
    product_price = models.DecimalField(max_digits=10, decimal_places=2)
    stock_quantity = models.IntegerField(default=0)
    # Return at least one object
    def __str__(self) -> str:
        return self.product_name

"""
Staff class: Creates possible system administrative roles
"""
class Staff(models.Model):
    staff_id = models.AutoField(primary_key=True)
    staff_name = models.CharField(max_length=50)
    staff_role = models.CharField(max_length=20, choices=[
        ('Manager', 'Manager'),
        ('Salesperson', 'Salesperson'),
        ('Cashier', 'Cashier')
    ])
    staff_email = models.EmailField(max_length=50, unique=True, validators=[EmailValidator()])
    staff_phone = models.CharField(max_length=15, unique=True)
    password = models.CharField(max_length=100, default="password")  # Store hashed password
    # Return at least one object
    def __str__(self) -> str:
        return f"{self.staff_name} ({self.staff_role})"

"""
class Sale: Store possible sales records
"""
class Sale(models.Model):
    sale_id = models.AutoField(primary_key=True)
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    sale_date = models.DateTimeField(auto_now_add=True)
    quantity_sold = models.IntegerField()
    total_amount = models.DecimalField(max_digits=10, decimal_places=2)
    payment_status = models.CharField(max_length=20, choices=[
        ('Paid', 'Paid'),
        ('Pending', 'Pending'),
        ('Refunded', 'Refunded')
    ])
    delivery_address = models.TextField(max_length=200, default='Unknown')
    delivery_status = models.CharField(max_length=20, choices=[
        ('Delivered', 'Delivered'),
        ('Not Delivered', 'Not Delivered')
    
    ], default="Not Delivered")
    # Return at least one object from the class
    def __str__(self) -> str:
        return f"Sale {self.sale_id} - {self.product.product_name} to {self.customer.customer_name}"

"""
Delivery class: Keep track of sale delivery
"""
class Delivery(models.Model):
    delivery_id = models.AutoField(primary_key=True)
    sales = models.ForeignKey(Sale, on_delete=models.CASCADE)
    delivery_date = models.DateField()
    delivery_status = models.CharField(max_length=20, choices=[
        ('Delivered', 'Delivered'),
        ('Not Delivered', 'Not Delivered')
    
    ])
    # Return at least one object
    def __str__(self) -> str:
        return self.delivery_status


    
