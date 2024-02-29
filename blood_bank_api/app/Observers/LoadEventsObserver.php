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

         // Retrieve data from EmergencyRequestBlood table based on erId
         $relatedData = LoadEvents::where('eventId', $loadEvents->eventId)->first();

         $notificationTitle = "Join Us!! New Event going to be held";
         $notificationBody = "Event: {$relatedData->eventName}, at {$relatedData->localLevel},{$relatedData->district}";
                            
          
         // Construct the additional data to be sent with the notification
         $notificationData = [
         'evId' => $relatedData->eventId,
 
         ];
 
         // for sending notification when request created 
            // Construct the notification payload
     $notificationPayload = [
         'to' => '/topics/mobilebloodbanknepalnotifications',
         'notification' => [
             'body' => $notificationBody,
             'title' => $notificationTitle,
             'android_channel_id' => 'Blood Bank Nepal',
             'sound' => true
         ],
         'data' => $notificationData // Include additional data
     ];
 
     // Convert the payload to JSON
     $notificationJson = json_encode($notificationPayload);
 
     // Send the notification using cURL
 
         $curl = curl_init();
 
         curl_setopt_array($curl, array(
             CURLOPT_URL => 'https://fcm.googleapis.com/fcm/send',
             CURLOPT_RETURNTRANSFER => true,
             CURLOPT_ENCODING => '',
             CURLOPT_MAXREDIRS => 10,
             CURLOPT_TIMEOUT => 0,
             CURLOPT_FOLLOWLOCATION => true,
             CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
             CURLOPT_CUSTOMREQUEST => 'POST',
             CURLOPT_POSTFIELDS => $notificationJson,
             CURLOPT_HTTPHEADER => array(
                 'Authorization: key=AAAA1dOfHzM:APA91bFInBV5DhVZr8g7IoTmV-3vFG3yDftHUDzcBF4uCP55l2O3lLrnCMQmyYVLswaa7zY3JBN45OKzJWRI-8r7LOKZNtVgsdWEyxfhmx6UBzAjjRvWcaWvUeapQe9KHa72tOvzauXn',
                 'Content-Type: application/json',
                 'mbbnserverkeyForAuthentication: AAAA1dOfHzM:APA91bFInBV5DhVZr8g7IoTmV-3vFG3yDftHUDzcBF4uCP55l2O3lLrnCMQmyYVLswaa7zY3JBN45OKzJWRI-8r7LOKZNtVgsdWEyxfhmx6UBzAjjRvWcaWvUeapQe9KHa72tOvzauXn'
             ),
           ));
       
           $response = curl_exec($curl);
       
           curl_close($curl);
           echo $response;
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
