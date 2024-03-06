<?php

namespace App\Observers;

use App\Models\EmergencyRequestBlood;
use App\Models\RegDonor;
use App\Models\DeviceToken;
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

        // retrieve donorId associated with erId
        $donorId = EmergencyRequestBlood::where('emergencyRequestId', $emergencyRequestBlood->emergencyRequestId)->pluck('doId');

        // retrieve userId from associated with donorId
        $userId = RegDonor::where('donorId', $donorId)->value('userId');

        // retrieve all device tokens except asscociated with that userId        
        $deviceTokens = DeviceToken::where('userId', '<>', $userId)->pluck('deviceToken')->toArray();


         // Retrieve data from EmergencyRequestBlood table based on erId
        $relatedData = EmergencyRequestBlood::where('emergencyRequestId', $emergencyRequestBlood->emergencyRequestId)->first();


        $notificationTitle = "New Emergency Request for Blood Group '{$relatedData->bloodGroup}'";
        $notificationBody = "Location: {$relatedData->localLevel}, {$relatedData->district}";
                           
         
        // Construct the additional data to be sent with the notification
        $notificationData = [
        'erId' => $relatedData->emergencyRequestId,

        ];

        // for sending notification when request created 
           // Construct the notification payload
           // if to all then 'to' => '/topics/mobilebloodbanknepalnotifications',
    $notificationPayload = [        
        'registration_ids' => $deviceTokens,
        'notification' => [
            'body' => $notificationBody,
            'title' => $notificationTitle,
            'android_channel_id' => 'Mobile Blood Bank Nepal',
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
                'Authorization: key=AAAABACREP8:APA91bGKITEOT_juJIAPDB-CtRRrFrlG5yCSLDtrJuJR8XvmrWythds7L-p4qm1cK_DfyF8p_xaxNMR4GLXNhsaUu6imygggMKhaPVSUGPzG010RJzH0NWPXW0pArFqfZmBW5zrAHENl',
                'Content-Type: application/json',
                'mbbnserverkeyForAuthentication: AAAABACREP8:APA91bGKITEOT_juJIAPDB-CtRRrFrlG5yCSLDtrJuJR8XvmrWythds7L-p4qm1cK_DfyF8p_xaxNMR4GLXNhsaUu6imygggMKhaPVSUGPzG010RJzH0NWPXW0pArFqfZmBW5zrAHENl'
            ),
          ));
      
          $response = curl_exec($curl);
      
          curl_close($curl);
          echo $response;
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
