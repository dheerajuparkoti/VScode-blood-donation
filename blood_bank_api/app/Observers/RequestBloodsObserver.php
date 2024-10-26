<?php

namespace App\Observers;

use App\Models\RequestBlood;
use App\Models\RegDonor;
use App\Models\DeviceToken;
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
         // retrieve donorId associated with erId
         $donorId = RequestBlood::where('requestId', $requestBlood->requestId)->pluck('doId');

         // retrieve userId from associated with donorId
         $userId = RegDonor::where('donorId', $donorId)->value('userId');
 
         // retrieve all device tokens except asscociated with that userId        
         $deviceTokens = DeviceToken::where('userId', '<>', $userId)->pluck('deviceToken')->toArray();

         // Retrieve data from EmergencyRequestBlood table based on erId
         $relatedData = RequestBlood::where('requestId', $requestBlood->requestId)->first();


         $notificationTitle = "New Request for Blood Group '{$relatedData->bloodGroup}'";
         $notificationBody = "Location: {$relatedData->localLevel}, {$relatedData->district}";
                            
          
         // Construct the additional data to be sent with the notification
         $notificationData = [
         'rId' => $relatedData->requestId,
 
         ];
 
         // for sending notification when request created 
            // Construct the notification payload
            foreach ($deviceTokens as $deviceToken) {
                $notificationPayload = [
                    'message' => [
                        'token' => $deviceToken, // Send to a single token here
                        'notification' => [
                            'title' => $notificationTitle,
                            'body' => $notificationBody,
                        ],
                        'data' => [
                            'story_id' => $notificationData['story_id'] ?? 'default_story_id', // Include additional data
                        ],
                        'android' => [
                            'notification' => [
                                'click_action' => 'TOP_STORY_ACTIVITY',
                                'body' => $notificationBody,
                            ],
                        ],
                        'apns' => [
                            'payload' => [
                                'aps' => [
                                    'alert' => [
                                        'title' => $notificationTitle,
                                        'body' => $notificationBody,
                                    ],
                                    'category' => 'NEW_MESSAGE_CATEGORY',
                                    'sound' => 'default',
                                ],
                            ],
                        ],
                    ],
                ];
    
 
     // Convert the payload to JSON
     $notificationJson = json_encode($notificationPayload);
 
     // Send the notification using cURL
 
         $curl = curl_init();
 
         curl_setopt_array($curl, array(
            CURLOPT_URL => 'https://fcm.googleapis.com/v1/projects/mobile-blood-bank-nepal-a2399/messages:send',
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => '',
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => 'POST',
            CURLOPT_POSTFIELDS => $notificationJson,
            CURLOPT_HTTPHEADER => array(
                'Authorization: Bearer ya29.c.c0ASRK0GYS1d4oJhmiSb4AEA417bvpmicMDs5fwDnnapeL60VueaaAQPObSc0PE67RH-pov09nS-kSBI0nJ1pD7bfuPgdKHvhFvef007P5jTSJjVUlJ_t2O8QPlu7Tp8ZgEfe4XP4SpE1R0mm4EMAx0-xEJ5pqGiiQlHDD8SjLpp1AVSbBSWnSU_WiLqZtjXKspo1i1QLUXsBJilLKUZtHjNt6MjIOOhiQm2rKOj37SEFJuwZoYMkE5_9vLMIsuE7wrtHl_mv2a1xH5NLTmG7i0OhvUqfGJ4_Iw6ChhvFxP3yApge2aldPRDj1Kn7nDGPObq-AhWLKg5PxagVVtoUSLQkY_NPSTx8za7Cx3Ru2bJrdcSk5u2uRdibP6QQG388DZr1oR7kjRhb43qusWtVzhufJecuz5XZO7mRR-ayyRbRy8Y0cqVqbWlQsh74tiSi4tJBJllsf9Bqad70WQsxWMj7uZyaYrR0_x3eliXgS_YOM1pvk5x9l4cv0mg56qk6QoiaVgXah5c6QhcS4J7twsq46kgoyO2ZgZdu7oMcI4tjFXdfovzq5av7Rck8VI6MYZQYhF0t_f41-7OyFmivxJjYUY747Rxyb12VMyBoxde21uihYiffXktmVoO3toOrtSh6pXYrOp0r-aV-hizR2nd3f9lrMReOpp5v_zB35Yl4S4sWsIkJWW7UhBVFcfS7vRhOV7xMYFd0fsee14O_s2MWoe-uJVYZt3n-dj147-RSm_snbfSkcIVxFI8F-MRduYdm5fM1Rq80vkmwgmrsOv3O_bJZVQfUJiq28Q9zkkgxo6nSvF8YwR0_1wZ0cc_cmW_eQa3dB3j-_uiQk6RZyU_kJxjZRdqbfuJy93MX9cFUOubf3eiyBBMbW8tcRIBw-4Y0Ui1mgtFmoo3wSyVj52kI-M6j-OS7-nz6rRYd3V8I9wx4qOfht5oJ9-edvI0j-6o6SWZ8S0ZYz4m8bYUdIb9ax1oJItYvrzoJ747Qb',
                'Content-Type: application/json',
            ),
        ));

           $response = curl_exec($curl);
       
           curl_close($curl);
           echo $response;
    }
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
