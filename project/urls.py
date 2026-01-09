"""
URL configuration for project project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from app.views import Index, CustomerSignup, CreateStaff, StaffDashboard, CustomerDashboard, CustomerMakeOrders, CustomerUpdateProfile, SalesPerson, SalesPersonUpdateProfile, ConfirmDelivery, GenerateReport, ManagerUpdateProfile

urlpatterns = [
    path('admin/', admin.site.urls),
    path("", include("app.urls")),
    path("index/", Index.index, name="index"),
    path("signup/", CustomerSignup.signup, name="signup"),
    path("create_staff/", CreateStaff.create_staff, name="create_staff"),
    path("login_staff/", CreateStaff.login_staff, name="login_staff"),
    path("manager/", StaffDashboard.manager_dashboard, name="manager"),
    path("add_stock/", StaffDashboard.add_stock, name="add_stock"),
    path("update_stock/<int:stock_id>/", StaffDashboard.update_stock, name="update_stock"),
    path("customer/", CustomerDashboard.as_view(), name="customer"),
    path("orders/", CustomerMakeOrders.as_view(), name="orders"),
    path("update_profile/<int:customer_id>/", CustomerUpdateProfile.as_view(), name="update_profile"),
    path("salesperson/", SalesPerson.as_view(), name="salesperson"),
    path("update_staff_profile/<int:staff_id>/", SalesPersonUpdateProfile.as_view(), name="update_salesperson_profile"),
    path("update_manager_profile/<int:staff_id>/", ManagerUpdateProfile.as_view(), name="update_manager_profile"),
    path("confirm_delivery/<int:sale_id>/", ConfirmDelivery.as_view(), name="confirm_delivery"),
    path("report/", GenerateReport.as_view(), name="generate_report"),

]
