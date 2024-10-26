@extends('admin.layouts.master')
@section('content') 
<div class="m-content">
    <div class="m-portlet">
        <div class="m-portlet__head">
            <div class="m-portlet__head-wrapper">
                <div class="m-portlet__head-caption">
                    <div class="m-portlet__head-title">
                        <h3 class="m-portlet__head-text">
                            OUR DONORS
                        </h3>
                    </div>
                </div>
                <div class="m-portlet__head-tools">
                    <a href="https://www.facebook.com/" class="btn btn-success m-btn m-btn--icon m-btn--wide m-btn--md m--margin-right-10">
                        <span>
                            <i class="fa fa-plus"></i>
                            <span>Create</span>
                        </span>                         
                    </a>
                    <!-- import button-->
                    <a href="https://www.facebook.com/" class="btn btn-primary m-btn m-btn--icon m-btn--wide m-btn--md m--margin-right-10">
                        <span>
                            <i class="fa fa-upload"></i>
                            <span>Import</span>
                        </span>
                    </a>
                    <!-- Delete button-->
                    <a href="https://www.facebook.com/" class="btn btn-danger m-btn m-btn--icon m-btn--wide m-btn--md m--margin-right-10">
                        <span>
                            <i class="fa fa-trash-alt"></i>
                            <span>Delete</span>
                        </span>
                    </a>
                </div>
            </div>
        </div>
        <div class="m-portlet__body">
            <div class="m-section">
                <div class="m-section__content">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover" id="bloods-table">
                            <thead>
                                <tr class="table-primary">
                                    <th>ID</th>
                                    <th>profilePic</th>
                                    <th>Name</th>
                                    <th>DOB</th>
                                    <th>Gender</th>
                                    <th>Blood</th>
                                    <th>province</th>
                                    <th>district</th>
                                    <th>localLevel</th>
                                    <th>wardNo</th>                                    
                                    <th>Phone</th>
                                    <th>Email</th>  
                                    <th>canDonate</th> 
                                    <th>donorId</th>                               
                                </tr>
                            </thead>
                           <tbody>                             
                            

                             
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
 <script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script> 
<script>
    $(document).ready(function() {
    var url =  {!! json_encode ({{route('admin.blood-bank')}})   !!}
        $('#bloods-table').DataTable({
            processing: true,
            serverSide: true,
            ajax: url,
            columns: [
                { data: 'donorId', name:'donorId'},
                { data: 'profilePic', name:'profilePic'},
                { data: 'fullName', name:'fullName'},
                { data: 'dob', name:'dob'},
                { data: 'gender', name:'gender'},
                { data: 'bloodGroup', name:'bloodGroup'},
                { data: 'province', name:'province'},
                { data: 'district', name:'district'},
                { data: 'localLevel', name:'localLevel'},
                { data: 'wardNo', name:'wardNo'},              
                { data: 'phone', name:'phone'},
                { data: 'email', name:'email'},
                { data: 'canDonate', name:'canDonate'},
                { data: 'userId', name:'userId'},
                // Add more columns as needed
            ],
        });
    });
</script>
@endpush
