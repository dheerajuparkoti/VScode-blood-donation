<?php

namespace App\Observers;

use App\Models\EmergencyRequestBlood;
use App\Models\Notification;


class EmergencyRequestBloodsObserver
{
    /**
     * Handle the EmergencyRequestBlood "created" event.
     */
    public function created(EmergencyRequestBlood $emergencyRequestBlood): void
    {
       
        Notification::create([
            'erId' => $emergencyRequestBlood->emergencyRequestId,
            // Add other fields as needed
        ]);
    }

    /**
     * Handle the EmergencyRequestBlood "updated" event.
     */
    public function updated(EmergencyRequestBlood $emergencyRequestBlood): void
    {
        //
    }

    /**
     * Handle the EmergencyRequestBlood "deleted" event.
     */
    public function deleted(EmergencyRequestBlood $emergencyRequestBlood): void
    {
        //
    }

    /**
     * Handle the EmergencyRequestBlood "restored" event.
     */
    public function restored(EmergencyRequestBlood $emergencyRequestBlood): void
    {
        //
    }

    /**
     * Handle the EmergencyRequestBlood "force deleted" event.
     */
    public function forceDeleted(EmergencyRequestBlood $emergencyRequestBlood): void
    {
        //
    }
}
