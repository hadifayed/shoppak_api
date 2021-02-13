Steps to set up the project:
1 - install ngrok to make the app reachable by Twilio
  - follow steps in this link to install it https://ngrok.com/download

2 - expose port 3000 by ngrok (./ngrok http 3000)

3 - ngrok will inform us with two url we can use to access our local project copy one of them

4 - make duplicate of '/shoppak_api/config/local_env.yml.example' and name it 'local_env.yml'

5 - paste the URL copied from step 3 into the new created file from step 4

6 - run 'docker-compose up --build' to start the app

List of endpoint to use the app:
1 - registration  POST /auth
  request body {name: 'hadi', phone_number: '+201025700212', password: '01025700212'}

2 - sign-in  POST /auth/sign_in (this method generates the headers required to access other endpoint)
  request body {phone_number: '+201025700212', password: '01025700212'}
  this request return in the headers these attributes which are required to be sent in the headers of any request
   which requires authentication [access-token, token-type, client, uid, expiry]

3 - List transactions GET /transactions requires authentication using request num 2
  request headers {access-token: '', token-type: '', client: '', uid: '', expiry: ''}

4 - create transaction POST /transactions requires authentication using request num 2
  request headers {access-token: '', token-type: '', client: '', uid: '', expiry: ''}
  request body { transaction: { receiver_id: OTHER USER ID, amount: INTEGER } }

5 - view current wallet get /my_wallet
  request headers {access-token: '', token-type: '', client: '', uid: '', expiry: ''} 
