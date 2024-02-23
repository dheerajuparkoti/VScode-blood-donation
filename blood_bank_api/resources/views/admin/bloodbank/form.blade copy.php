<div class="m-section">
    <div class="m-section__content">
        <div class="form-group row">
            <div class="col-lg-6">
                {!! Form::label('name', 'Name :') !!}
                {!! Form::text('name', null, ['class' => 'form-control']) !!}

                @error('name')
                    <div id="name-id-error" class="error invalid-feedback"> {{ $message }}</div>
                @enderror

            </div>

            <div class="col-lg-6">
                {!! Form::label('display_name', 'Contact Number :') !!}
                {!! Form::text('contactNo', null, ['class' => 'form-control']) !!}

                @error('display_ncontactNoame')
                    <div id="contactNo-id-error" class="error invalid-feedback"> {{ $message }}</div>
                @enderror
            </div>
        </div>
        <div class="form-group row">
            <div class="col-lg-6">
            {!! Form::label('province', 'Province :') !!}
            {!! Form::select('province', $provinces, null, ['class' => 'form-control', 'id' => 'province']) !!}

                @error('name')
                    <div id="name-id-error" class="error invalid-feedback"> {{ $message }}</div>
                @enderror

            </div>

            <div class="col-lg-6">
            {!! Form::label('district', 'District :') !!}
            {!! Form::select('district', $districts, null, ['class' => 'form-control', 'id' => 'district']) !!}

                @error('display_ncontactNoame')
                    <div id="contactNo-id-error" class="error invalid-feedback"> {{ $message }}</div>
                @enderror
            </div>
        </div>
        <div class="form-group row">
            <div class="col-lg-6">
            {!! Form::label('localLevel', 'Local Level :') !!}
    {!! Form::select('localLevel', $localLevels, null, ['class' => 'form-control', 'id' => 'localLevel']) !!}

                @error('localLevel')
                    <div id="name-id-error" class="error invalid-feedback"> {{ $message }}</div>
                @enderror

            </div>

            <div class="col-lg-6">
                {!! Form::label('display_name', 'Ward Number :') !!}
                {!! Form::text('wardNo', null, ['class' => 'form-control']) !!}

                @error('wardNo')
                    <div id="contactNo-id-error" class="error invalid-feedback"> {{ $message }}</div>
                @enderror
            </div>
        </div>
</div>

<div class="kt-portlet__foot">
    <div class="kt-form__actions">
        <div class="row">
            <div class="col-lg-6">
                <button type="submit" class="btn btn-primary">{{ $formAction }}</button>
                <a href="{{ route('admin-ambulance-create') }}" type="reset" class="btn btn-secondary">Cancel</a>
            </div>
        </div>
    </div>
</div>
</div>
