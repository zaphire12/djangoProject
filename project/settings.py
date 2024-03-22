from pathlib import Path
import environ
import os

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


env = environ.Env()
environ.Env.read_env(os.path.join(BASE_DIR, '.env'))

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.0/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = env('SECRET_KEY')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = []


# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'api_v1',
    'api_v2',
    'basic_auth',
    'app',
    'django_celery_results'
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'project.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates']
        ,
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'basic_auth.context_processors.params_processor',
                # 'basic_auth.context_processors.celery_uri_processor',
                'app.context_processor.notification_len_processor',
                'app.context_processor.available_modules'
            ],
        },
    },
]

WSGI_APPLICATION = 'project.wsgi.application'


# Database
# https://docs.djangoproject.com/en/5.0/ref/settings/#databases

DATABASES = {
   'default': {
       'ENGINE': 'django.db.backends.postgresql',
       'NAME': 'djangoProject',
       'USER': 'gen_user',
       'PASSWORD': env('PASSWORD'),
       'HOST': '172.16.1.144',
       'PORT': '5432',
   }
}


# Password validation
# https://docs.djangoproject.com/en/5.0/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/5.0/topics/i18n/

LANGUAGE_CODE = 'ru'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.0/howto/static-files/

STATIC_URL = 'static/'


STATICFILES_DIRS = [
    BASE_DIR / "static",
    BASE_DIR / "node_modules",
]

MEDIA_ROOT = BASE_DIR / 'media'


# Default primary key field type
# https://docs.djangoproject.com/en/5.0/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

AUTH_USER_MODEL = 'basic_auth.User'

LOGIN_URL = 'basic_auth:login'

LOGOUT_REDIRECT_URL = 'basic_auth:login'


EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"
EMAIL_HOST = 'mail.infomed39.ru'
EMAIL_HOST_USER = 'dash@infomed39.ru'
EMAIL_HOST_PASSWORD = env('EMAIL_HOST_PASSWORD')
EMAIL_USE_SSL = False
EMAIL_USE_TLS = True
EMAIL_PORT = '587'
DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
SERVER_EMAIL = EMAIL_HOST
EMAIL_ADMIN = "n.nebiev@infomed39.ru"

AG_GRID_DATE_FORMAT = '%d/%m/%Y'

DOC_TYPE_LIST = [
    'Выписной эпикриз из роддома (ИР)',
    'Инструментальные',
    'Консультации',
    'Лаборатория',
    'МСПС',
    'МСР',
    'МСС',
    'МСЭ',
    'Прием фельдшера',
    'Протокол прижизненного патологоанатомического исследования',
    'Сведения о результатах диспансеризации или профилактического медицинского осмотра',
    'Телемедицина',
    'Эпикриз в стационаре выписной (ИБ)',
    'Этапный эпикриз'
]

IGNORE_LPU = [
  'ГБСОУ КО Госпиталь для ветеранов войн Калининградской области',
  'БФУ им. И. Канта',
  'МИАЦ',
  'Специализированный дом ребенка Калининградской области № 1',
  'Тестовое ЛПУ',
  'ФБУЗ ЦГиЭ в Калининградской области',
  'Федеральное государственное бюджетное учреждение «1409 Военно-морской '
  'клинический госпиталь» Министерства обороны Российской Федерации',
  'ЧУЗ "Больница "РЖД-Медицина" города Калининград']

# CELERY

CELERY_TASK_TRACK_STARTED = True
CELERY_BROKER_URL = 'redis://localhost:6379/0'
CELERY_RESULT_BACKEND = 'django-db'

# ORACLE
ORACLE_DB = env('ORACLE_DB')
