Project Scope:
  - It is needed to create an API for simple mobile app that allows users to
    transfer money to each other

Project features:
  1. Registration
      - User should be able to register with Name, Mobile number and password
      - Upon sign up app should create a wallet for user with USD 1000 Credit
  2. Sign in
      - User should be able to sign in with previously registered Mobile and password.
  3. Viewing Wallet balance
  4. Viewing List of transactions made
  5. Creating new transfer
      - User can initiate a transfer to another user using their ID
      - After the user initiates a transfer an automated call should be made to his
         registered mobile number. Call will ask for user confirmation by pressing 123​ as
         a security code. If the user confirmed the transfer then transfer should be
         processed. Transfer will expire after 5 minutes if no confirmation is received.

Steps to set up the project:
  1. install ngrok to make the app reachable by Twilio
     follow steps in this link to install it https://ngrok.com/download
  2. expose port 3000 by ngrok (./ngrok http 3000)
  3. ngrok will inform us with two url we can use to access our local project copy one of them
  4. make duplicate of `/wallet_api/config/local_env.yml.example` and name it `local_env.yml`
  5. paste the URL copied from step 3 into `local_env.yml` file created from step 4
  6. add your twilio credentials to `local_env.yml` file created from step 4 to activate the automated phone call checks
  6. run `docker-compose up --build` to start the app

List of endpoint to use the app:
  1. registration  POST /auth
      request body {name: 'hadi', phone_number: '+201025700212', password: '01025700212'}

  2. sign-in  POST /auth/sign_in (this method generates the headers required to access other endpoint)
      request body {phone_number: '+201025700212', password: '01025700212'}
      this request return in the headers these attributes which are required to be sent in the headers of any request
      that requires authentication [access-token, token-type, client, uid, expiry]

  3. List transactions GET /transactions requires authentication using request num 2
      request headers {access-token: '', token-type: '', client: '', uid: '', expiry: ''}

  4. create transaction POST /transactions requires authentication using request num 2
      request headers {access-token: '', token-type: '', client: '', uid: '', expiry: ''}
      request body { transaction: { receiver_id: OTHER USER ID, amount: INTEGER } }

  5. view current wallet get /my_wallet
      request headers {access-token: '', token-type: '', client: '', uid: '', expiry: ''}

Possible improvements :
  1. add specs
