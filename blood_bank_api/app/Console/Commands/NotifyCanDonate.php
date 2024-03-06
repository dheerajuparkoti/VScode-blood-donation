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

                // Prepare the notification payload
                $notificationPayload = [
                    'registration_ids' => $deviceTokens,
                    'notification' => [
                        'title' => $notificationTitle,
                        'body' => $notificationBody,
                        'android_channel_id' => 'Mobile Blood Bank Nepal',
                        'sound' => true
                    ],
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
        }

        \Log::info('Scheduler check executed at: ' . now()->toDateTimeString());
        \Log::info('Notification system check...'); // Add more details as needed
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
