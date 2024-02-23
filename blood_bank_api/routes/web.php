<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\DashboardController; 
use App\Http\Controllers\Admin\BloodBankController; 

use App\Http\Controllers\Admin\AmbulanceInfoController;
use App\Http\Controllers\Admin\BloodBankInfoController;

use App\Http\Controllers\Admin\RequestBloodController;
use App\Http\Controllers\Admin\EmergencyRequestBloodController;

use App\Http\Controllers\Admin\RegDonorController;
use App\Http\Controllers\Admin\RegUserController;

use App\Http\Controllers\Admin\SetAppointmentController;
use App\Http\Controllers\Admin\LoadEventsController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/


Route::get('/admin/dashboard',[DashboardController::class, 'index'])->name('admin.dashboard'); 
Route::get('/admin/donors',[BloodBankController::class, 'index'])->name('admin.blood-bank'); 


//Event Details
Route::get('/admin/event',[LoadEventsController::class, 'index'])->name('admin-event-data');
Route::delete('/admin/event/{id}',[LoadEventsController::class, 'destroy'])->name('admin-event-delete');
Route::get('/admin/event/show',[LoadEventsController::class, 'show'])->name('admin-event-show');
Route::get('/admin/event/addEvent',[LoadEventsController::class, 'addEvent'])->name('admin-event-addEvent');
Route::post('/admin/event/store',[LoadEventsController::class, 'store'])->name('admin-event-store');


//Retrieve Appointments Details
Route::get('/admin/appointment',[SetAppointmentController::class, 'index'])->name('admin-appointment-data');
Route::delete('/admin/appointment/{id}',[SetAppointmentController::class, 'destroy'])->name('admin-appointment-delete');
Route::get('/admin/appointment/show',[SetAppointmentController::class, 'show'])->name('admin-appointment-show');


//Request Blood 
Route::get('/admin/requestBlood',[RequestBloodController::class, 'index'])->name('request-blood');
Route::delete('/admin/requestBlood/{id}',[RequestBloodController::class, 'destroy'])->name('request-delete');
Route::get('/admin/requestBlood/show',[RequestBloodController::class, 'show'])->name('request-show');

//Emergency Request Blood 
Route::get('/admin/emergencyRequestBlood',[EmergencyRequestBloodController::class, 'index'])->name('emergency-request-blood');
Route::delete('/admin/emergencyRequestBlood/{id}',[EmergencyRequestBloodController::class, 'destroy'])->name('emergency-request-delete');
Route::get('/admin/emeregencyRequestBlood/show',[EmergencyRequestBloodController::class, 'show'])->name('emergency-request-show');

//Ambulance Data retrieving 
Route::get('/admin/ambulance',[AmbulanceInfoController::class, 'index'])->name('admin-ambulance-data');
Route::get('/admin/ambulance/create',[AmbulanceInfoController::class, 'create'])->name('admin-ambulance-create');
Route::get('/admin/ambulance/import',[AmbulanceInfoController::class, 'import'])->name('admin-ambulance-import');
Route::get('/admin/ambulance/export',[AmbulanceInfoController::class, 'export'])->name('admin-ambulance-export');
Route::post('/admin/ambulance/import',[AmbulanceInfoController::class, 'storeImport'])->name('admin-ambulance-import-store');
Route::post('/admin/ambulance',[AmbulanceInfoController::class, 'store'])->name('admin-ambulance-store');
Route::delete('/admin/ambulance/{id}',[AmbulanceInfoController::class, 'destroy'])->name('admin-ambulance-delete');
Route::get('/admin/ambulance/show',[AmbulanceInfoController::class, 'show'])->name('admin-ambulance-show');
Route::get('/get-districts', [AmbulanceInfoController::class, 'getDistricts'])->name('get-districts');
Route::get('/get-local-levels', [AmbulanceInfoController::class, 'getLocalLevels'])->name('get-local-levels');


//blood Bank Data retrieving 
Route::get('/admin/bloodbank/data',[BloodBankInfoController::class, 'index'])->name('admin-bloodbank-data');
Route::get('/admin/bloodbank/create',[BloodBankInfoController::class, 'create'])->name('admin-bloodbank-create');
Route::get('/admin/bloodbank/import',[BloodBankInfoController::class, 'import'])->name('admin-bloodbank-import');
Route::get('/admin/bloodbank/export',[BloodBankInfoController::class, 'export'])->name('admin-bloodbank-export');
Route::post('/admin/bloodbank/import',[BloodBankInfoController::class, 'storeImport'])->name('admin-bloodbank-import-store');
Route::post('/admin/bloodbank/store',[BloodBankInfoController::class, 'store'])->name('admin-bloodbank-store');
Route::delete('/admin/bloodbank/{id}',[BloodBankInfoController::class, 'destroy'])->name('admin-bloodbank-delete');
Route::get('/admin/bloodbank/show',[BloodBankInfoController::class, 'show'])->name('admin-bloodbank-show');
Route::get('/get-districts', [BloodBankInfoController::class, 'getDistricts'])->name('get-districts');
Route::get('/get-local-levels', [BloodBankInfoController::class, 'getLocalLevels'])->name('get-local-levels');

//Donors Data Retrieving 
Route::get('/admin/donor/data',[RegDonorController::class, 'index'])->name('admin-donor-data');
Route::get('/admin/donor/create',[RegDonorController::class, 'create'])->name('admin-donor-create');
Route::get('/admin/donor/import',[RegDonorController::class, 'import'])->name('admin-donor-import');
Route::get('/admin/donor/export',[RegDonorController::class, 'export'])->name('admin-donor-export');
Route::post('/admin/donor/import',[RegDonorController::class, 'storeImport'])->name('admin-donor-import-store');
Route::post('/admin/donor/store',[RegDonorController::class, 'store'])->name('admin-donor-store');
Route::delete('/admin/donor/{id}',[RegDonorController::class, 'destroy'])->name('admin-donor-delete');
Route::get('/admin/donor/show',[RegDonorController::class, 'show'])->name('admin-donor-show');
Route::get('/get-districts', [BloodBankInfoController::class, 'getDistricts'])->name('get-districts');
Route::get('/get-local-levels', [BloodBankInfoController::class, 'getLocalLevels'])->name('get-local-levels');

//User Data Retrieving
Route::get('/admin/users',[RegUserController::class, 'index'])->name('users-data');
Route::delete('/admin/users/{id}',[RegUserController::class, 'destroy'])->name('users-delete');
Route::get('/admin/users/{id}/edit',[RegUserController::class, 'edit'])->name('users-edit');
Route::get('/admin/users/show',[RegUserController::class, 'show'])->name('users-show');



Route::get('/', function () {
    return view('welcome');
});
