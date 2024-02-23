<!DOCTYPE html>
<html lang="en">

<!-- begin::Head -->
@include('admin.includes.header-link')
<!-- Link to your CSS file -->
<link href="{{ asset('/styles.css') }}" rel="stylesheet">

<!-- end::Head -->

<!-- begin::Body -->
<body class="m-page--fluid m--skin- m-content--skin-light2 m-header--fixed m-header--fixed-mobile m-aside-left--enabled m-aside-left--skin-dark m-aside-left--offcanvas m-footer--push m-aside--offcanvas-default">

<!-- begin:: Page -->
<div class="m-grid m-grid--hor m-grid--root m-page">

    <!-- BEGIN: Header -->
    @include('admin.includes.header')

    <!-- END: Header -->

    <!-- begin::Body -->

    <div class="m-grid__item m-grid__item--fluid m-grid m-grid--ver-desktop m-grid--desktop m-body">

        <!-- BEGIN: Left Aside -->
            @include('admin.includes.sidebar')

        <!-- END: Left Aside -->
        <div class="m-grid__item m-grid__item--fluid m-wrapper" id="app">

            <!-- BEGIN: Subheader -->
                    @yield('breadcrumbs');
<!-- {{--                @include('user.admin.includes.sub-header')--}} -->

            <!-- END: Subheader -->
            @yield('content')
        </div>
    </div>

    <!-- end:: Body -->

    <!-- begin::Footer -->
        @include('admin.includes.footer')

    <!-- end::Footer -->
</div>

<!-- end:: Page -->

<!-- begin::Scroll Top -->
<div id="m_scroll_top" class="m-scroll-top">
    <i class="la la-arrow-up"></i>
</div>

<!-- end::Scroll Top -->

@include('admin.includes.script-footer')
@stack('script')
</body>

<!-- end::Body -->
</html>
