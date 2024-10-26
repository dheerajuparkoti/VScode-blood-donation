import 'package:googleapis_auth/auth_io.dart';
class GetServerKey{
  Future<String> getServerKeyToken()async{
    final scopes=[
      'https://www.googleapis.com/auth/userinfo.email', 
      'https://www.googleapis.com/auth/firebase.database', 
      'https://www.googleapis.com/auth/firebase.messaging',
     
    ];
    final client = await clientViaServiceAccount(ServiceAccountCredentials.fromJson(
 {
  "type": "service_account",
  "project_id": "mobile-blood-bank-nepal-a2399",
  "private_key_id": "0f5dd3faf9622be7badbe93166b1c31723434016",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDK6d9F0yLrDC1a\n8cs3Ybk9Xu1aL3mEcuvHUph3V6HutBn2i/WORIpQnpfBLT2SFIgs2pX4cHT9d/L9\nGev+IgVjzN+9SGfLEaYBEuPs4/Cn/xB4oQJW+LgP7Y9D8AsXvO/iIMfUeZKZ8EZL\nW+tWYtRzRSaRsgTxXnRDeOLOkXVVlLjF2DpdNTLasdvouZvBrDNvQwrZKSEjR8fU\nJTIMiYuozR17FH3JBZ5ajtkn3absxa2hUEOvR7zIRTFtBzbU4l+QNR5WPDeZFz3D\nEZE+JOrw9m62VAR+C0g0m2wVvdoKsHUQIg21+BtGgZE0zoK+tmlRmNvn4h4n+Ueq\nSiZ2W9PJAgMBAAECggEAKzPPM10oTpYpo/beNxzp5TysWWrJOx+Cvs4Bo0s3sYyM\nCJe1AQTr1A1oLxuUQ+F2OuKRUrOS3RKoXCYkPlf9AMoyiuj7HFvWFd1xRNMlPoeK\neLyDNIRBIDcKrULTActa4bDsCvuVcIwdU1cvTJW/OQmslBGshr1/EIyQ8b07l6ww\n6slxTMa+M37L94wUSEYkLCMKG6Ok8gGNUfD/3vpFFTF9Lv2StNujCSh5MReKaOT2\nnEmMUGsPO/5VMbgM9bZY3j9LQaqP4IdWZ39kb8ziFn9QIgHBKBPt7E/ihyKed565\nZVUpnFvS8VxihGg5sS+k08cELcER3iyPTbuelfTBuQKBgQDsa1jJ33PWjke4yPJR\nJ94fH1hMhC4010I6LTrVw4Y8d1CIab2x2gozjUSk2xJTCX2OAgWthw1UmpRxFgwV\nvHBh/Z2vnmMzSRMfs4/NKVTi6W28HI271ls+DXsI+RTF9b+CatV4gQvayWndtAEe\n8bd4azv7aTDL7sZX3syO4786tQKBgQDbuB+TmkrxRzHse0Nh0jjsC5vGZrUj1rQ+\ngTK0bEXJjpXdwe4WsohiuVZ0FLakTWkHNRkYN5iFwJdBVYlI95SuvD6gHgOuYmU+\n7n7uvi7bq18Tba4xEHa731bvR65AFPS+zAl7IsBvQDi33UF8Upu9jIy1G/lUXZKR\nq9NgC5CdRQKBgQCgjipHNmw5qniEwlrlyHhtlGDn3eBvXDyKu8q3/0f7amATtBPy\nY4wIBIk4l9oy8EAHH9JxTUU9Tpk+z2U3obiEo7Lh4GOoIZlOLyiagNY4H6S5Wn7a\nsLFYS9lhd56m7cS4Mgt1AdZmJ+Cwgp08QZWCvviGPaK47Bhg9lrfM0Xb/QKBgHcM\n/t8FPRIa12whJdN9Cqara45G3GM81JEBhC3KdM3PWli72Xum5MtJTRS8nHHOF9h1\n5tD+XsAqKEqYRDirHX7INM6hNLFqUx2UMGa/2bfg1TU7uqSPHSaSzxH7rui98hbn\ni0OTAt3E2HaXhgIM6KH948fGDoSt5trTVUa3PXZZAoGBAI+nc+CrFryPheY4v55o\nMkJqeGLjU6NM6vwALqfphn4oxhLYlcCYBVh76a3/pIBmecF8P8CfMqXddrkbG1rE\npADzj3XbCBaZHDuoxKIkU2VCqB2tC649Thxrnh83xH8ka0rCFOwuniMDcnmw4mBh\nEbicd/Mj6m0q/I9G1XlWpdPj\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-cmv1d@mobile-blood-bank-nepal-a2399.iam.gserviceaccount.com",
  "client_id": "103739600164225141779",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-cmv1d%40mobile-blood-bank-nepal-a2399.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

    ),
    scopes
    );
    final accessServerKey= client.credentials.accessToken.data;
    return accessServerKey;
  }
}
