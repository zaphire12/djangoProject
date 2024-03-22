from django import forms
from .models import NotificationModel
from basic_auth.models import User


class SelectMultipleCustom(forms.SelectMultiple):
    template_name = "widgets/select.html"
    option_template_name = "widgets/select_option.html"


class UserChangeFormCustom(forms.ModelForm):
    username = forms.CharField(label="Логин", widget=forms.TextInput(attrs={
        'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}))

    class Meta:
        model = User
        fields = ['username', 'first_name', 'last_name', 'email', 'is_verified', 'is_active', 'available_lpu', 'groups', 'user_permissions']
        widgets = {
            'user_permissions': forms.SelectMultiple(attrs={
                'data-te-select-init': '',
                'data-te-select-filter': "true",
                'data-te-class-select-input': "dark:bg-neutral-700 peer mt-6 block min-h-[auto] w-full rounded border-0 bg-transparent outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-gray-200 dark:placeholder:text-gray-200 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0 cursor-pointer data-[te-input-disabled]:bg-[#e9ecef] data-[te-input-disabled]:cursor-default group-data-[te-was-validated]/validation:mb-4 dark:data-[te-input-disabled]:bg-zinc-600",
                'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}),

            'groups': forms.SelectMultiple(attrs={
                'data-te-select-init': '',
                'data-te-select-filter': "true",
                'data-te-class-select-input':"dark:bg-neutral-700 peer mt-6 block min-h-[auto] w-full rounded border-0 bg-transparent outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-gray-200 dark:placeholder:text-gray-200 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0 cursor-pointer data-[te-input-disabled]:bg-[#e9ecef] data-[te-input-disabled]:cursor-default group-data-[te-was-validated]/validation:mb-4 dark:data-[te-input-disabled]:bg-zinc-600",
                'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}),
            'available_lpu': forms.SelectMultiple(attrs={
                'data-te-select-init': '',
                'data-te-select-filter': "true",
                'data-te-class-select-input':"dark:bg-neutral-700 peer block min-h-[auto] w-full rounded border-0 bg-transparent outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-gray-200 dark:placeholder:text-gray-200 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0 cursor-pointer data-[te-input-disabled]:bg-[#e9ecef] data-[te-input-disabled]:cursor-default group-data-[te-was-validated]/validation:mb-4 dark:data-[te-input-disabled]:bg-zinc-600",
                'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}),
            'email': forms.TextInput(attrs={
                'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}),
            'first_name': forms.TextInput(attrs={
                'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}),
            'last_name': forms.TextInput(attrs={
                'class': 'peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[2.15] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:bg-neutral-700 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0'}),
        }


class UserNotificationForm(forms.ModelForm):
    class Meta:
        model = NotificationModel
        fields = ['user', 'news']

