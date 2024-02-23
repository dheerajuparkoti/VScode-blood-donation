<?php

namespace App\Observers;

use App\Models\LoadEvents;
use App\Models\Notification;


class LoadEventsObserver
{
    /**
     * Handle the LoadEvents "created" event.
     */
    public function created(LoadEvents $loadEvents): void
    {
        Notification::create([
            'evId' => $loadEvents->eventId,
            // Add other fields as needed
        ]);
    }

    /**
     * Handle the LoadEvents "updated" event.
     */
    public function updated(LoadEvents $loadEvents): void
    {
        //
    }

    /**
     * Handle the LoadEvents "deleted" event.
     */
    public function deleted(LoadEvents $loadEvents): void
    {
        //
    }

    /**
     * Handle the LoadEvents "restored" event.
     */
    public function restored(LoadEvents $loadEvents): void
    {
        //
    }

    /**
     * Handle the LoadEvents "force deleted" event.
     */
    public function forceDeleted(LoadEvents $loadEvents): void
    {
        //
    }
}
