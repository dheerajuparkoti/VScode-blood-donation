<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Pagination\Paginator;
use App\Models\RequestBlood; // Import the RequestBlood model
use App\Models\EmergencyRequestBlood; // Import the EmergencyRequestBlood model
use App\Models\LoadEvents; // Import the LoadEvent model
use App\Observers\RequestBloodsObserver;
use App\Observers\EmergencyRequestBloodsObserver;
use App\Observers\LoadEventsObserver;


class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
        Paginator::useBootstrap();
        RequestBlood::observe(RequestBloodsObserver::class);
        EmergencyRequestBlood::observe(EmergencyRequestBloodsObserver::class);
        LoadEvents::observe(LoadEventsObserver::class);
    }
}
