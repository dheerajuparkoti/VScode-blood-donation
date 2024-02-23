<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\LoadEvents;
use App\Models\RegDonor;
use App\Models\EventStatus;

class EventStatusController extends Controller
{
    //
    public function likeEvent(Request $request)
    {
             
         // Validate the request data
         $request->validate([
            'eventId' => 'required|exists:load_events,eventId',
            'donorId' => 'required|exists:reg_donors,donorId',
        ]);

        // Find the event status record
        $eventStatus = EventStatus::where('evId', $request->eventId)
                                  ->where('doId', $request->donorId)
                                  ->first();

        // If the event status record exists, toggle the like status
        if ($eventStatus) {
            $eventStatus->like = !$eventStatus->like;
            $eventStatus->save();
        } else {
            // If the event status record doesn't exist, create a new one
            EventStatus::create([
                'evId' => $request->eventId,
                'doId' => $request->donorId,
                'like' => true,
            ]);
        }

        // Return response
        return response()->json(['message' => 'Event like status toggled successfully']);

        
      
    }

    public function attendEvent(Request $request)
    {
      
         // Validate the request data
         $request->validate([
            'eventId' => 'required|exists:load_events,eventId',
            'donorId' => 'required|exists:reg_donors,donorId',
        ]);

        // Find the event status record
        $eventStatus = EventStatus::where('evId', $request->eventId)
                                  ->where('doId', $request->donorId)
                                  ->first();

        // If the event status record exists, toggle the attend status
        if ($eventStatus) {
            $eventStatus->attend = !$eventStatus->attend;
            $eventStatus->save();
        } else {
            // If the event status record doesn't exist, create a new one
            EventStatus::create([
                'evId' => $request->eventId,
                'doId' => $request->donorId,
                'attend' => true,
            ]);
        }

        // Return response
        return response()->json(['message' => 'Event attend status toggled successfully']);
}




}
