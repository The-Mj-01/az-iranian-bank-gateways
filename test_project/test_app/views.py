import logging

from django.http import HttpResponse, Http404
from django.shortcuts import render
from django.urls import reverse

from azbankgateways import bankfactories, models as bank_models, default_settings as settings
from azbankgateways.exceptions import AZBankGatewaysException


def home_view(request):
    """صفحه اصلی برای تست درگاه"""
    return render(request, 'test_app/home.html')


def go_to_gateway_view(request):
    """هدایت به درگاه بانک سامان"""
    if request.method == "POST":
        try:
            amount = int(request.POST.get('amount', 10000))
            mobile_number = request.POST.get('mobile_number', '')
            
            factory = bankfactories.BankFactory()
            bank = factory.create(bank_models.BankType.SEP)
            bank.set_request(request)
            bank.set_amount(amount)
            
            # یو آر ال بازگشت به نرم افزار
            bank.set_client_callback_url(reverse('test_app:callback-gateway'))
            
            if mobile_number:
                bank.set_mobile_number(mobile_number)
            
            # آماده‌سازی و ذخیره رکورد
            bank_record = bank.ready()
            
            # هدایت کاربر به درگاه بانک
            context = bank.get_gateway()
            return render(request, "azbankgateways/redirect_to_bank.html", context=context)
            
        except AZBankGatewaysException as e:
            logging.critical(f"خطا در اتصال به درگاه: {e}")
            return render(request, 'test_app/error.html', {'error': str(e)})
        except Exception as e:
            logging.critical(f"خطای غیرمنتظره: {e}")
            return render(request, 'test_app/error.html', {'error': str(e)})
    
    return render(request, 'test_app/payment_form.html')


def callback_gateway_view(request):
    """بازگشت از درگاه بانک"""
    tracking_code = request.GET.get(settings.TRACKING_CODE_QUERY_PARAM, None)
    if not tracking_code:
        logging.debug("این لینک معتبر نیست.")
        raise Http404

    try:
        bank_record = bank_models.Bank.objects.get(tracking_code=tracking_code)
    except bank_models.Bank.DoesNotExist:
        logging.debug("این لینک معتبر نیست.")
        raise Http404

    context = {
        'bank_record': bank_record,
        'is_success': bank_record.is_success,
        'status': bank_record.status,
        'amount': bank_record.amount,
        'tracking_code': bank_record.tracking_code,
        'reference_number': bank_record.reference_number,
    }
    
    return render(request, 'test_app/result.html', context)

