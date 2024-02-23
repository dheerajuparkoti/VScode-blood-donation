<?php

namespace App\Exports\Admin;

use App\Models\BloodBankInfo;
use App\Models\RegDonor;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;

class BloodBankInfoExport implements FromCollection, WithHeadings
{
    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection()
    {
        // Perform a join between BloodBankInfo and RegDonor tables
        $data = BloodBankInfo::leftJoin('reg_donors', 'blood_bank_infos.doId', '=', 'reg_donors.donorId')
            ->select(
                'blood_bank_infos.name',
                'blood_bank_infos.contactNo',
                'blood_bank_infos.province',
                'blood_bank_infos.district',
                'blood_bank_infos.localLevel',
                'blood_bank_infos.wardNo',
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
            'Blood Bank Name',
            'Contact No',
            'Province',
            'District',
            'Local Level',
            'Ward No',
            'Added By'
        ];
    }
}
