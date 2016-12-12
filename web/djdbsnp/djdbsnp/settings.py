"""
Django settings for dbsnp project.

Generated by 'django-admin startproject' using Django 1.10.

For more information on this file, see
https://docs.djangoproject.com/en/1.10/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.10/ref/settings/
"""

import os

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.10/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get('DJANGO_SECRET_KEY') or 'SECRET_SECRET_SECRET_SECRET_SECRET'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = os.environ.get('DJANGO_DEBUG') or False

ALLOWED_HOSTS = [os.environ.get('DJANGO_ALLOWED_HOSTS') or '127.0.0.1']

# Application definition

INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    'rest_framework',

    'dbsnp',
)

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'djdbsnp.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'djdbsnp.wsgi.application'

# dbsnp
DBSNP_DB_NAME = os.environ.get('DBSNP_DB_NAME') or 'dbsnp_b146_GRCh37'
DBSNP_DB_USER = os.environ.get('DBSNP_DB_USER') or 'dbsnp'
DBSNP_DB_PASS = os.environ.get('DBSNP_DB_PASS') or 'dbsnp'
DBSNP_DB_HOST = os.environ.get('DBSNP_DB_HOST') or '127.0.0.1'
DBSNP_DB_PORT = os.environ.get('DBSNP_DB_PORT') or '5432'
DBSNP_BUILD   = os.environ.get('DBSNP_BUILD') or 'b146'
DBSNP_REF_GENOME_BUILD = os.environ.get('DBSNP_REF_GENOME_BUILD') or 'GRCh37.p13'
DBSNP_QUERY_COUNTS_LIMIT = 30


# Database
# https://docs.djangoproject.com/en/1.10/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': DBSNP_DB_NAME,
        'USER': DBSNP_DB_USER,
        'PASSWORD': DBSNP_DB_PASS,
        'HOST': DBSNP_DB_HOST,
        'PORT': DBSNP_DB_PORT,
    },
    'dbsnp': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': DBSNP_DB_NAME,
        'USER': DBSNP_DB_USER,
        'PASSWORD': DBSNP_DB_PASS,
        'HOST': DBSNP_DB_HOST,
        'PORT': DBSNP_DB_PORT,
    }
}


# Password validation
# https://docs.djangoproject.com/en/1.10/ref/settings/#auth-password-validators

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
# https://docs.djangoproject.com/en/1.10/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.10/howto/static-files/

STATIC_URL = '/static/'
