@extends('admin.layouts.master')
@section('content') 
<div class="m-content">
    <div class="m-portlet">
        <div class="m-portlet__head">
            <div class="m-portlet__head-wrapper">
                <div class="m-portlet__head-caption">
                    <div class="m-portlet__head-title">
                    <head>
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
                            <link href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css" relation="stylesheet"> 
                    </head>
                        <h3 class="m-portlet__head-text">
                            BLOOD REQUESTS LIST
                        </h3>
                    </div>
                </div>
                <div class="m-portlet__head-tools">                    
                 
                </div>
            </div>
        </div>
        <div class="m-portlet__body">
            <div class="m-section">
                <div class="m-section__content">
                    
                <!-- retrieving message from controller if deleted successfully-->  
                @if(session()->has('message'))
                <div class="alert alert-success">
                    {{ session()->get('message') }}
                </div>
                @endif

                @if(isset($message))
                <div class="alert alert-info">
                    {{ $message }}
                </div>
                @endif

                <!-- Search Bar -->
                <form action="{{ route('request-show') }}" method="GET">
                    <div class="form-row align-items-center mb-3">
                        <div class="col-auto">
                            <label class="sr-only" for="requiredDate">Required Date</label>
                            <input type="text" class="form-control" id="requiredDate" name="requiredDate" placeholder="Search by Requested Date">
                        </div>                        
                        <div class="col-auto">
                            <input type="text" class="form-control" name="address" placeholder="Search by Address">
                        </div>
                        <div class="col-auto">
                            <label class="sr-only" for="hospitalName">hospitalName</label>
                            <input type="text" class="form-control" id="hospitalName" name="hospitalName" placeholder="Search by Hospital">
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary">Search Now</button>
                        </div>
                    </div>
                </form>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover" id="requestTable">
                        <thead>
                            <tr class="table-primary">
                                <th>Re. Id</th>
                                <th>Patient Name</th>
                                <th>Blood Group</th>
                                <th>Re. Pint</th>
                                <th>Case Detail</th>
                                <th>Contact Person</th>     
                                <th>Contact Number</th>  
                                <th>Re. Date</th>  
                                <th>Re. Time</th>                                                                                       
                                <th>Hospital Name</th>
                                <th>Hospital Address</th> 
                                <th> Available Donors </th>
                                <th>Delete Action</th>
                            </tr>
                        </thead>
                    
                    
                            <tbody>
                                @foreach ($requestBlood as $requests)
                                <tr class="dd">
                                    <td>{{ $requests->requestId }}</td>
                                    <td>{{ $requests->fullName}}</td>
                                    <td>{{ $requests->bloodGroup}}</td>
                                    <td>{{ $requests->requiredPint}}</td> 
                                    <td>{{ $requests->caseDetail}}</td>  
                                    <td>{{ $requests->contactPersonName}}</td>   
                                    <td>{{ $requests->contactNo}}</td>  
                                    <td>{{ $requests->requiredDate}}</td>  
                                    <td>{{ $requests->requiredTime}}</td>  
                                    <td>{{ $requests->hospitalName}}</td>  
                                    <td>{{ $requests->localLevel }},- {{ $requests->wardNo }}, {{ $requests->district }}, Pro. {{ $requests->province }}</td>                                
                                    <td>{{ $requests->availableDonorsCount }}</td> <!-- New column showing available donors count -->
                                    <td style="text-align: center; vertical-align: middle;">
                                        <form method="POST" action="{{ route('request-delete', ['id' => $requests->requestId]) }}">
                                            @csrf
                                            @method('DELETE')
                                            <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this request? Once you delete, you will not be able to revert the changes!')" style="padding: 5px 10px;">
                                                <div class="d-flex align-items-center justify-content-center">Delete</div>
                                            </button>
                                        </form>
                                    </td>                    
                                </tr>
                                @endforeach
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="12">
                                        <!-- Pagination links -->
                                        <div class="pagination justify-content-center">
                                            {{ $requestBlood->onEachSide(2)->links() }}
                                        </div>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                        
                   
                </div>      
            </div>
            </div>
        </div>
    </div>
</div>
@endsection
