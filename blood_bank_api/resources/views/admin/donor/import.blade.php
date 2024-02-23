@extends('admin.layouts.master')

@section('content')
<div class="m-content">
    <div class="m-portlet">
        <div class="m-portlet__head">
            <div class="m-portlet__head-wrapper">
                <div class="m-portlet__head-caption">
                    <div class="m-portlet__head-title">
                        <h3 class="m-portlet__head-text">
                            Donor Data Import
                        </h3>
                    </div>
                </div>
                <div class="m-portlet__head-tools">
                </div>
            </div>
        </div>
        <div class="m-portlet__body">
            {!! Form::open(['route' => ['admin-donor-import-store'], 'method' => 'post', 'class' => 'kt-form kt-form--label-right', 'files' => true]) !!}
            <div class="m-section">
                <div class="m-section__content">
                    <div class="form-group row">
                        <div class="col-lg-6">
                            {!! Form::label('name', 'File :') !!}
                            {!! Form::file('file', null, ['class' => 'form-control']) !!}
                            @error('file')
                                <div id="name-id-error" class="error invalid-feedback"> {{ $message }}</div>
                            @enderror
                        </div>
                    </div>
                </div>

                <div class="kt-portlet__foot">
                    <div class="kt-form__actions">
                        <div class="row">
                            <div class="col-lg-6">
                                <button type="submit" class="btn btn-primary">Import</button>
                                <a href="{{ route('admin-donor-data') }}" type="reset" class="btn btn-secondary">Cancel</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            {!! Form::close() !!}
        </div>
    </div>
</div>
@endsection
