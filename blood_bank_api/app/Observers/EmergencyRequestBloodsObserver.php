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

        // for sending notification when request created 
       

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
          //for sending all 
          //"registration_ids": [
            //    "e4GXealwSBGgYrliHokzdg:APA91bEyFQ9c4zkbtpPit8wLefNyFCI9WR074JuewGAWpY8oTBnj7thljDyatEVD-ha57zpcKpTnTQfF3HbciwwayOrbE3Re_95hu4OkOhqzxdqO4Mq30ljXvFLLIul7xngqLdDBrYTw"
           // ],
          CURLOPT_POSTFIELDS =>'{
        
              

                 "to": "/topics/mobilebloodbanknepalnotifications",
             
            "notification": {
                "body": "Postman Demo",
                "title": "Blood Bank Nepal",
                "android_channel_id": "Blood Bank Nepal",       
                "sound": true
            }
        }',
          CURLOPT_HTTPHEADER => array(
            'Authorization: key=AAAA1dOfHzM:APA91bFInBV5DhVZr8g7IoTmV-3vFG3yDftHUDzcBF4uCP55l2O3lLrnCMQmyYVLswaa7zY3JBN45OKzJWRI-8r7LOKZNtVgsdWEyxfhmx6UBzAjjRvWcaWvUeapQe9KHa72tOvzauXn',
            'Content-Type: application/json'
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
