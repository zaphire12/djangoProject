from django import forms
from django.contrib.auth import get_user_model, authenticate, password_validation
from django.contrib.auth.forms import AuthenticationForm, UserCreationForm, PasswordChangeForm, PasswordResetForm, \
    SetPasswordForm
from django.core.exceptions import ValidationError
from django.utils.translation import gettext as _


class PasswordResetFormCustom(PasswordResetForm):
    email = forms.EmailField(
        label="Email",
        max_length=254,
        widget=forms.EmailInput(attrs={"autocomplete": "email",
                                       'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}),
    )


class SetPasswordFormCustom(SetPasswordForm):
    new_password1 = forms.CharField(
        label=_("New password"),
        widget=forms.PasswordInput(attrs={
            "autocomplete": "new-password",
            'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'
        }),
        strip=False,
        help_text=password_validation.password_validators_help_text_html(),
    )
    new_password2 = forms.CharField(
        label=_("New password confirmation"),
        strip=False,
        widget=forms.PasswordInput(attrs={
            "autocomplete": "new-password",
            'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'

        }),
    )

    def save(self, commit=True):
        password = self.cleaned_data["new_password1"]
        self.user.set_password(password)
        self.user.is_verified = False
        if commit:
            self.user.save()
        return self.user


class SelectMultipleCustom(forms.SelectMultiple):
    template_name = "widgets/select.html"
    option_template_name = "widgets/select_option.html"


class RegisterUserForm(UserCreationForm):
    username = forms.CharField(label="Логин", widget=forms.TextInput(attrs={
        'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}))
    password1 = forms.CharField(label="Пароль", widget=forms.PasswordInput(attrs={
        'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}))
    password2 = forms.CharField(label="Повтор пароля", widget=forms.PasswordInput(attrs={
        'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}))

    class Meta:
        model = get_user_model()
        fields = ['username', 'email', 'first_name', 'last_name', 'password1', 'password2', 'available_lpu']
        labels = {
            'email': 'E-mail',
            'first_name': "Имя",
            'last_name': "Фамилия",
        }
        widgets = {
            'available_lpu': forms.SelectMultiple(attrs={
                'data-te-select-init': '',
                'data-te-select-filter': "true",
                'data-te-class-select-input': "dark:bg-neutral-700 peer block min-h-[auto] w-full rounded border-0 bg-transparent outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-gray-200 dark:placeholder:text-gray-200 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0 cursor-pointer data-[te-input-disabled]:bg-[#e9ecef] data-[te-input-disabled]:cursor-default group-data-[te-was-validated]/validation:mb-4 dark:data-[te-input-disabled]:bg-zinc-600",
                'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}),
            'email': forms.TextInput(attrs={
                'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}),
            'first_name': forms.TextInput(attrs={
                'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}),
            'last_name': forms.TextInput(attrs={
                'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}),
        }

    def clean_email(self):
        email = self.cleaned_data['email']
        if email:
            if get_user_model().objects.filter(email=email).exists():
                raise forms.ValidationError("Такой E-mail уже существует!")
            return email
        else:
            raise forms.ValidationError("Укажите E-mail!")


class LoginUserForm(AuthenticationForm):
    username = forms.CharField(label="Логин", widget=forms.TextInput(attrs={
        'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}
    ))
    password = forms.CharField(label="Пароль", widget=forms.PasswordInput(attrs={
        'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}))

    def get_invalid_verified(self):
        return ValidationError(
            self.error_messages["inactive"],
            code="inactive",
            params={"username": self.username_field.verbose_name},
        )

    def clean(self):
        username = self.cleaned_data.get("username")
        password = self.cleaned_data.get("password")
        if username is not None and password:
            self.user_cache = authenticate(
                self.request, username=username, password=password
            )
            if self.user_cache is None:
                raise self.get_invalid_login_error()
            elif not self.user_cache.is_verified or not self.user_cache.is_active:
                raise self.get_invalid_verified()
            else:
                self.confirm_login_allowed(self.user_cache)
        return self.cleaned_data

    class Meta:
        model = get_user_model()
        fields = ['username', 'password']


class UserPasswordChangeForm(PasswordChangeForm):
    old_password = forms.CharField(label="Старый пароль", widget=forms.PasswordInput(attrs={
        'class': 'peer block min-h-[auto] dark:bg-neutral-700 w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-300 dark:placeholder:text-neutral-200 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}))
    new_password1 = forms.CharField(label="Новый пароль", widget=forms.PasswordInput(attrs={
        'class': 'peer block min-h-[auto] dark:bg-neutral-700 w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}))
    new_password2 = forms.CharField(label="Подтверждение пароля", widget=forms.PasswordInput(attrs={
        'class': 'peer block min-h-[auto] dark:bg-neutral-700 w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}))
