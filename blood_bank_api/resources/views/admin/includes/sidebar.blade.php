<button class="m-aside-left-close  m-aside-left-close--skin-dark " id="m_aside_left_close_btn"><i
        class="la la-close"></i></button>
<div id="m_aside_left" class="m-grid__item	m-aside-left  m-aside-left--skin-dark ">

    <!-- BEGIN: Aside Menu -->
    <div id="m_ver_menu" class="m-aside-menu  m-aside-menu--skin-dark m-aside-menu--submenu-skin-dark "
         m-menu-vertical="1" m-menu-scrollable="0" m-menu-dropdown-timeout="500">
        <ul class="m-menu__nav ">

              <!-- For Main Dashboard-->

            <li class="m-menu__item" aria-haspopup="true">
                <a href="{{ route('admin.dashboard') }}" class="m-menu__link ">
                    <span class="m-menu__item-here"></span>
                    <i class=""></i>
                    <span class="m-menu__link-text">Dashboard</span>
                </a>
            </li>
          
               <!-- Donor Data -->
<li class="m-menu__item m-menu__item--submenu m-menu__item--close" aria-haspopup="true" data-menu-submenu-toggle="click">
    <a href="#" class="m-menu__link m-menu__toggle">
        <span class="m-menu__item-here"></span>
        <i class=""></i>
        <span class="m-menu__link-text">Our Donor</span>
        <i class="m-menu__ver-arrow la la-angle-right"></i>
    </a>
    <div class="m-menu__submenu">
        <span class="m-menu__arrow"></span>
        <ul class="m-menu__subnav">
            <li class="m-menu__item" aria-haspopup="true">
                <a href="{{route('admin-donor-data')}}" class="m-menu__link">
                    <i class="m-menu__link-icon flaticon-eye"></i>
                    <span class="m-menu__link-text">Show Data</span>
                </a>
            </li>           
        </ul>
    </div>
</li>

            
             <!-- Requests Info -->
<li class="m-menu__item m-menu__item--submenu 
" aria-haspopup="true" data-menu-submenu-toggle="click">
    <a href="#" class="m-menu__link m-menu__toggle">
        <span class="m-menu__item-here"></span>
        <i class=""></i>
        <span class="m-menu__link-text">Blood Requests</span>
        <i class="m-menu__ver-arrow la la-angle-right"></i>
    </a>
    <div class="m-menu__submenu">
        <span class="m-menu__arrow"></span>
        <ul class="m-menu__subnav">
            <li class="m-menu__item" aria-haspopup="true">
                <a href="{{route('request-blood')}}" class="m-menu__link">
                    <i class="m-menu__link-icon flaticon-eye"></i>
                    <span class="m-menu__link-text">Normal Requests</span>
                </a>
            </li>
            <li class="m-menu__item" aria-haspopup="true">
                <a href="{{route('emergency-request-blood')}}" class="m-menu__link">
                    <i class="m-menu__link-icon flaticon-eye"></i>
                    <span class="m-menu__link-text">Emergency Requests</span>
                </a>
            </li>
        </ul>
    </div>
</li>
         

              <!-- Blood Bank Info -->
<li class="m-menu__item m-menu__item--submenu m-menu__item--close" aria-haspopup="true" data-menu-submenu-toggle="click">
    <a href="#" class="m-menu__link m-menu__toggle">
        <span class="m-menu__item-here"></span>
        <i class=""></i>
        <span class="m-menu__link-text">Blood Bank Info</span>
        <i class="m-menu__ver-arrow la la-angle-right"></i>
    </a>
    <div class="m-menu__submenu">
        <span class="m-menu__arrow"></span>
        <ul class="m-menu__subnav">
            <li class="m-menu__item" aria-haspopup="true">
                <a href="{{route('admin-bloodbank-data')}}" class="m-menu__link">
                    <i class="m-menu__link-icon flaticon-eye"></i>
                    <span class="m-menu__link-text">Show Data</span>
                </a>
            </li>           
        </ul>
    </div>
</li>

               <!-- Ambulance Info -->
<li class="m-menu__item m-menu__item--submenu m-menu__item--close" aria-haspopup="true" data-menu-submenu-toggle="click">
    <a href="#" class="m-menu__link m-menu__toggle">
        <span class="m-menu__item-here"></span>
        <i class=""></i>
        <span class="m-menu__link-text">Ambulance Info</span>
        <i class="m-menu__ver-arrow la la-angle-right"></i>
    </a>
    <div class="m-menu__submenu">
        <span class="m-menu__arrow"></span>
        <ul class="m-menu__subnav">
            <li class="m-menu__item" aria-haspopup="true">
                <a href="{{route('admin-ambulance-data')}}" class="m-menu__link">
                    <i class="m-menu__link-icon flaticon-eye"></i>
                    <span class="m-menu__link-text">Show Data</span>
                </a>
            </li>
            
        </ul>
    </div>
</li>


              <!-- Events Info -->
              <li class="m-menu__item m-menu__item--submenu m-menu__item--close" aria-haspopup="true" data-menu-submenu-toggle="click">
    <a href="#" class="m-menu__link m-menu__toggle">
        <span class="m-menu__item-here"></span>
        <i class=""></i>
        <span class="m-menu__link-text">Events</span>
        <i class="m-menu__ver-arrow la la-angle-right"></i>
    </a>
    <div class="m-menu__submenu">
        <span class="m-menu__arrow"></span>
        <ul class="m-menu__subnav">
            <li class="m-menu__item" aria-haspopup="true">
                <a href="{{route('admin-event-data')}}" class="m-menu__link">
                    <i class="m-menu__link-icon flaticon-eye"></i>
                    <span class="m-menu__link-text">Our Events</span>
                </a>
            </li>          
        </ul>
    </div>
</li>
            <!-- Appointments -->
            <li class="m-menu__item" aria-haspopup="true">
                <a href="{{route('admin-appointment-data')}}" class="m-menu__link ">
                    <span class="m-menu__item-here"></span>
                    <i class=""></i>
                    <span class="m-menu__link-text">Appointments</span>
                </a>
            </li>

     
              <!-- Our Users -->
              <li class="m-menu__item" aria-haspopup="true">
                <a href="{{route('users-data')}}" class="m-menu__link ">
                    <span class="m-menu__item-here"></span>
                    <i class=""></i>
                    <span class="m-menu__link-text">Users</span>
                </a>
            </li>




            


        </ul>
    </div>

    <!-- END: Aside Menu -->
</div>
