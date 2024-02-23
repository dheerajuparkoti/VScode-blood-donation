<?php

namespace App\Exports\Admin;

use App\Models\RegDonor;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;

class RegDonorExport implements FromCollection, WithHeadings
{
    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection()
    {
        // Perform a join between BloodBankInfo and RegDonor tables
        $data = RegDonor::leftJoin('reg_users', 'reg_donors.donorId', '=', 'reg_users.id')
            ->select(
                'reg_donors.fullName',
                'reg_donors.dob',
                'reg_donors.gender',
                'reg_donors.bloodGroup',                
                'reg_donors.province',
                'reg_donors.district',
                'reg_donors.localLevel',
                'reg_donors.wardNo',
                'reg_donors.phone',
                'reg_donors.email',
                'reg_donors.canDonate',
                'reg_donors.fullname'
            )
            ->get();

        return $data;
    }

    /**
     * @return array
     */
    public function headings(): array
    {
        return [
            'Donor Name',
            'Date of Birth',
            'Gender',
            'Blood Group',            
            'Province',
            'District',
            'Local Level',
            'Ward No',
            'Phone',
            'Email',
            'Can Donate',
            'Username'
        ];
    }
}
