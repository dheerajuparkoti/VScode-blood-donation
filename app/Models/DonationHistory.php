<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DonationHistory extends Model
{
    use HasFactory;
    protected $table = 'donation_histories';
    protected $primarykey = 'dhId';
    protected $fillable = ['donatedDate', 'donatedTo', 'bloodPint','contact', 'doId'];
}
