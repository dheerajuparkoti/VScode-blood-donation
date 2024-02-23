<?php

namespace App\Observers;

use App\Models\RequestBlood;
use App\Models\Notification;


class RequestBloodsObserver
{
    /**
     * Handle the RequestBlood "created" event.
     */
    public function created(RequestBlood $requestBlood): void
    {
        Notification::create([
            'rId' => $requestBlood->requestId,
            // Add other fields as needed
        ]);
    }

    /**
     * Handle the RequestBlood "updated" event.
     */
    public function updated(RequestBlood $requestBlood): void
    {
        //
    }

    /**
     * Handle the RequestBlood "deleted" event.
     */
    public function deleted(RequestBlood $requestBlood): void
    {
        //
    }

    /**
     * Handle the RequestBlood "restored" event.
     */
    public function restored(RequestBlood $requestBlood): void
    {
        //
    }

    /**
     * Handle the RequestBlood "force deleted" event.
     */
    public function forceDeleted(RequestBlood $requestBlood): void
    {
        //
    }
}
