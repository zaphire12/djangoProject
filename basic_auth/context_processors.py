def params_processor(request):
    user = request.user
    if user.is_anonymous:
        return {}
    params = request.session.get('params', False)
    return {'params': params}


def celery_uri_processor(request):
    user = request.user
    if user.is_anonymous:
        return {}
    new_url = request.build_absolute_uri().replace('8000', '5555')
    return {'celery_url': new_url}
