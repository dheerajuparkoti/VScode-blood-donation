<?php

namespace App\Imports\Admin;

use App\Models\RegDonor;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class RegDonorImport implements ToModel,WithHeadingRow
{
   
    /**
    * @param array $row
    * 
    * @return \Illuminate\Database\Eloquent\Model|null

    */
 
    public function model(array $row)
    {
       // dd($row);
        return new RegDonor([   
            'fullName' => $row['name'],
            'dob' => $row['dob'],
            'gender' => $row['gender'],
            'bloodGroup' => $row['bloodgroup'],
            'province' => $row['provinceno'],
            'district' => $row['district'],
            'localLevel' => $row['locallevel'],
            'wardNo' => $row['wardno'],
            'phone' => $row['phone'],
            'email' => $row['email'],   
            'userId' => $row['userid'],          
        ]);
    }
}
