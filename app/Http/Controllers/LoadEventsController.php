<?php

namespace App\Http\Controllers;


use Illuminate\Http\Request;
use App\Models\LoadEvents;
use App\Models\EventStatus;

class LoadEventsController extends Controller
{
   


    public function loadEvents(Request $request)
{     
 // Retrieve the donor ID from the request
 $donorId = $request->input('donorId');

 // Retrieve all events
 $events = LoadEvents::all();

 // Log the retrieved events
 \Log::info('Retrieved all events: ' . json_encode($events));

 // Initialize an empty array to store response data
 $responseEvents = [];

 // Loop through each event
 foreach ($events as $event) {
     // Retrieve event ID
     $eventId = $event->eventId;

     // Retrieve event details
     $eventDetails = [
         'eventId' => $eventId,
         'eventName' => $event->eventName,          
         'venue' => $event->venue,
         'chiefGuest' => $event->chiefGuest,
         'eventDetail' => $event->eventDetail,
         'organizedBy' => $event->organizedBy,
         'contactNo' => $event->contactNo,
         'province' => $event->province,
         'district' => $event->district,
         'localLevel' => $event->localLevel,
         'wardNo' => $event->wardNo,
         'eventDate' => $event->eventDate,
         'eventTime' => $event->eventTime,
     ];

     // Check if the donor has liked or attended the event
     $eventStatus = EventStatus::where('evId', $eventId)
                                ->where('doId', $donorId)
                                ->first();

     // If event status exists for the donor, set like and attend statuses
     if ($eventStatus) {
         $eventDetails['like'] = (bool) $eventStatus->like;
         $eventDetails['attend'] = (bool) $eventStatus->attend;
     } else {
         // If event status does not exist for the donor, set default values
         $eventDetails['like'] = false;
         $eventDetails['attend'] = false;
     }

     // Add event details to the response array
     $responseEvents[] = $eventDetails;
 }

 // Return the response containing all events with synchronized like and attend statuses
 return response()->json([
     'responseEvents' => $responseEvents,
 ]);

}
}
