<?php
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TestController;
use App\Http\Controllers\AuthController; 

use App\Http\Controllers\RegUserController; 
use App\Http\Controllers\RegDonorController; 

use App\Http\Controllers\RequestBloodController;
use App\Http\Controllers\EmergencyRequestBloodController;

use App\Http\Controllers\SetAppointmentController;
use App\Http\Controllers\SearchBloodController;
use App\Http\Controllers\LoadProfileController;
use App\Http\Controllers\LoadRequestController;
use App\Http\Controllers\NotificationController;

use App\Http\Controllers\AmbulanceInfoController; // load ambulance data or entry 
use App\Http\Controllers\BloodBankInfoController; // load bloodBank data or entry

use App\Http\Controllers\LoadEventsController;
use App\Http\Controllers\DonationHistoryController;

use App\Http\Controllers\EmergencyRequestAvailableDonorsController;
use App\Http\Controllers\RequestAvailableDonorsController;


use App\Http\Controllers\EventStatusController;
//public routes



/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});


// for login and logout session 

Route::post('/login',[AuthController::class,'login']); // method from AuthController
Route::middleware('auth:api')->post('/logout',[AuthController::class,'logout']);


Route::post('/checkUserExists',[RegUserController::class,'checkUserExists']); // for Checking Email or Phone for reset password


Route::post('/searchBlood',[SearchBloodController::class,'searchBlood']); // method from SearchBloodcontroller
Route::post('/loadProfile',[LoadProfileController::class,'loadProfile']); // method from LoadProfilecontroller
Route::post('/showProfile',[LoadProfileController::class,'loadProfile']); // method from LoadProfilecontroller

// signUp user 
Route::post('/regUser',[RegUserController::class,'regUser']); // for user registration
Route::post('/regDonor',[RegDonorController::class,'regDonor']); // for donor registration


//fetchUserData for settings screen
Route::post('/fetchingUserData',[RegUserController::class,'fetchingUserData']); 

//updatingUserData for settings screen
Route::post('/updateUserData',[RegUserController::class,'updateUserData']); 

// Donor profile update
Route::post('/updateDonorProfile',[RegDonorController::class,'updateDonorProfile']); // for donor registration

// count total no. of donors 
Route::get('/donorCountsByBloodGroup',[RegDonorController::class,'donorCountsByBloodGroup']); // for counting
Route::post('/getTopDonors',[RegDonorController::class,'getTopDonors']); // for counting

Route::post('/requestBlood',[RequestBloodController::class,'requestBlood']); // for making request blood i.e fill the request blood form
Route::post('/loadOtherRequests',[RequestBloodController::class,'loadOtherRequests']); // for making request blood i.e fill the request blood form

Route::post('/emergencyRequestBlood',[EmergencyRequestBloodController::class,'emergencyRequestBlood']); // for saving emergency request blood form
Route::post('/loadEmergencyRequests',[EmergencyRequestBloodController::class,'loadEmergencyRequests']); // for saving emergency request blood form

Route::post('/loadMyRequests', [LoadRequestController::class, 'loadMyRequests']); // for retrieving all my requests from request_blood and emergency_request_blood table

Route::post('/loadNotification', [NotificationController::class, 'loadNotification']); // for retrieving all my requests from request_blood and emergency_request_blood table
Route::post('/notificationReadErId',[NotificationController::class,'notificationReadErId']);
Route::post('/notificationReadReId',[NotificationController::class,'notificationReadReId']);
Route::post('/notificationReadEvent',[NotificationController::class,'notificationReadEvent']);


Route::post('/setAppointment',[SetAppointmentController::class,'setAppointment']); // setting Appointment 
Route::post('/loadEvents',[LoadEventsController::class,'loadEvents']); // loading Events

Route::post('/loadAmbulanceInfo',[AmbulanceInfoController::class,'loadAmbulanceInfo']); // loading Ambulance data
Route::post('/regAmbulance',[AmbulanceInfoController::class,'regAmbulance']); // Adding Ambulance data

Route::post('/loadBloodBankInfo',[BloodBankInfoController::class,'loadBloodBankInfo']); // loading BloodBank data
Route::post('/regBloodBank',[BloodBankInfoController::class,'regBloodBank']); // Adding BloodBank data

Route::post('/test',[TestController::class,'test']);


// For Adding New donation records
Route::post('/donationHistory',[DonationHistoryController::class,'donationHistory']); // for insertion
Route::post('/retrieveDonationHistory',[DonationHistoryController::class,'retrieveDonationHistory']); // for retrieving 


// For emergency_request_available_donors to make an entry 
Route::post('/erAvailableDonors',[EmergencyRequestAvailableDonorsController::class,'erAvailableDonors']);
// For request_available_donors to make an entry 
Route::post('/rAvailableDonors',[RequestAvailableDonorsController::class,'rAvailableDonors']);

//listing donors list who said im available for request 
Route::post('/rAvailableDonorList',[RequestAvailableDonorsController::class,'rAvailableDonorList']);
Route::post('/erAvailableDonorList',[EmergencyRequestAvailableDonorsController::class,'erAvailableDonorList']);


//Load the members added by Admin user
Route::post('/adminAddedDonors',[RegDonorController::class,'adminAddedDonors']); // for donor list added by the admin//superAdmin


// Event Status
Route::post('/likeEvent',[EventStatusController::class,'likeEvent']);
Route::post('/attendEvent',[EventStatusController::class,'attendEvent']); 
//Route::post('/loadEvents',[EventStatusController::class,'loadEvents']); 


//delete my request
Route::delete('/deleteRequest', [RequestBloodController::class, 'deleteRequest']);

//delete my Emergency request
Route::delete('/deleteEmergencyRequest', [EmergencyRequestBloodController::class, 'deleteEmergencyRequest']);