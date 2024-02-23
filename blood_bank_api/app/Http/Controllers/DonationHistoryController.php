<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\DonationHistory;
use App\Models\RegDonor;
use Carbon\Carbon;

class DonationHistoryController extends Controller
{
    //
    public function DonationHistory(Request $request)
    {
        // Step 1: Take input for userId, donorId, donatedDate
        $userId = $request->input('userId');
        $donorId = $request->input('donorId');
        $donatedDate = Carbon::parse($request->input('donatedDate'));

        // Step 2: Query the reg_donors table to check if the provided userId is associated with the given donorId
        $userExists = RegDonor::where('userId', $userId)
            ->where('donorId', $donorId)
            ->exists();

        // Step 3: If the association exists, proceed with the additional checks
        if ($userExists) {
            // Check if the donorId exists in the Donation History table
            $latestDonation = DonationHistory::where('doId', $donorId)
                ->latest('donatedDate')
                ->first();

            if ($latestDonation) {
                $daysSinceLastDonation = $donatedDate->diffInDays($latestDonation->donatedDate);

                if ($daysSinceLastDonation >= 75) {
                    // Create a new donation history record
                    $donationHistory = new DonationHistory();
                    $donationHistory->donatedDate = $donatedDate;
                    $donationHistory->donatedTo = $request->input('donatedTo');
                    $donationHistory->contact = $request->input('contact');
                    $donationHistory->bloodPint = $request->input('bloodPint');
                    $donationHistory->doId = $donorId;
                    $donationHistory->save();

                    return response()->json(['message' => 'Donation history created successfully'], 200);
                } else {
                    // Return error if the provided date is less than 75 days since the last donation
                    return response()->json(['message' => 'You cannot donate blood within 75 days of your last donation'], 403);
                }
            } else {
                // If no previous donations exist for this donor, create a new donation history record
                $donationHistory = new DonationHistory();
                $donationHistory->donatedDate = $donatedDate;
                $donationHistory->donatedTo = $request->input('donatedTo');
                $donationHistory->contact = $request->input('contact');
                $donationHistory->bloodPint = $request->input('bloodPint');
                $donationHistory->doId = $donorId;
                $donationHistory->save();

                return response()->json(['message' => 'Donation history created successfully'], 200);
            }
        } else {
            // If the association doesn't exist, return a message indicating that the user cannot update a guest user
            return response()->json(['message' => 'You cannot update this guest user'], 403);
        }
    }


    public function RetrieveDonationHistory(Request $request)
    {
        // Get the donorId from the request
        $donorId = $request->input('doId');
    
        // Count the total number of donation records associated with the specified donorId
        $totalDonationCountForDonor = DonationHistory::where('doId', $donorId)->count();
    
        // Retrieve the top 5 donation history records associated with the specified donorId
        $donationHistory = DonationHistory::where('doId', $donorId)
            ->orderByDesc('donatedDate')
            ->take(5)
            ->get();
    
        // Check if the last donation date exceeds 72 days
        $lastDonationDate = $donationHistory->max('donatedDate');
        $lastDonationExceeds72Days = now()->diffInDays($lastDonationDate) > 72;
    
        return response()->json([
            'donationHistory' => $donationHistory,
            'totalDonationTimes' => $totalDonationCountForDonor,
            'lastDonationExceeds72Days' => $lastDonationExceeds72Days
        ]);
    }
}


