<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RegDonor extends Model
{
    use HasFactory;

    protected $table = 'reg_donors';
    protected $primaryKey = 'donorId'; // Corrected primary key definition
    protected $guarded = ['id'];


    protected $fillable = [     
        'fullName',
        'dob',
        'gender',
        'bloodGroup',
        'province',
        'district',
        'localLevel',
        'wardNo',
        'phone',
        'email',   
        'userId',     
    ];
    

   

    public function user()
    {
        // Assuming userId is the foreign key in the reg_donors table
        return $this->belongsTo(RegUser::class, 'userId', 'id');
    }

    public function requestBloods() 
    {
        return $this->hasMany(RequestBlood::class, 'doId', 'donorId');
    }

    public function emergencyRequestBloods()
    {
        return $this->hasMany(EmergencyRequestBlood::class, 'doId', 'donorId');
    }



}
