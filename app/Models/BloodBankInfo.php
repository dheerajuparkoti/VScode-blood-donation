<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BloodBankInfo extends Model
{
    use HasFactory;
    protected $table = 'blood_bank_infos';
    protected $primaryKey = 'bloodBankInfoId';
    protected $guarded = ['id'];
}
