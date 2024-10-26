<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use App\Models\DonationHistory;
use App\Models\RegDonor;
use App\Models\DeviceToken;
use Carbon\Carbon;

class NotifyCanDonate extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:notify-can-donate';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Donor Can Donate Blood Now';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        // Get the last donation date for each donorId
        $lastDonationDates = DonationHistory::select('doId', DB::raw('MAX(donatedDate) as last_donation_date'))
            ->groupBy('doId')
            ->get();

        // Iterate through each donor's last donation date
        foreach ($lastDonationDates as $donation) {
            // Calculate the difference in days between the last donation date and today
            $lastDonationDate = Carbon::parse($donation->last_donation_date);
            $daysSinceLastDonation = $lastDonationDate->diffInDays(Carbon::now());

            // Check if the difference exceeds 75 days
            if ($daysSinceLastDonation > 75) {
                // Send push notification to the donor using FCM
                $donorId = $donation->doId;
                $relatedData = RegDonor::where('donorId', $donorId)->value('fullName');
                $notificationTitle = "Blood Donation Reminder";
                $notificationBody = "Dear {$relatedData}, You can donate blood again!";
                $deviceTokens = $this->getDeviceTokensForUser($donorId);

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
        \Log::info('Scheduler check executed at: ' . now()->toDateTimeString());
        \Log::info('Notification system check...'); // Add more details as needed
    }
}
    /**
     * Function to retrieve device tokens for a given donorId
     * You need to implement this function to fetch device tokens from your database
     */
    public function getDeviceTokensForUser($donorId)
    {
        // Find userId from reg_donors table using donorId
        $userId = RegDonor::where('donorId', $donorId)
        ->where('canDonate', 'Yes')
        ->value('userId');

        if ($userId) {
            // Extract device tokens using userId from device_tokens table
            $deviceTokens = DeviceToken::where('userId', $userId)->pluck('deviceToken')->toArray();
            return $deviceTokens;
        } else {
            // Return an empty array if userId is not found or donorId does not exist
            return [];
        }
    }
}
