import boto
import string
from secrets import choice


def generate_password():
    '''Generate a random password which satisfies the account password policy.
    '''
    alphabet = string.ascii_letters + string.digits
    while True:
        password = ''.join(choice(alphabet) for i in range(20))
        if (any(c.islower() for c in password)
                and any(c.isupper() for c in password)
                and any(c.isdigit() for c in password)):
            break
    return password


def create_user(event, context):
    '''Create a user with permission to assume roles and manage their credentials.

    We'd like to send them an email with instructions to get set up and send
    their password via another contact method too, but for now return it.
    '''
    iam = boto3.resource('iam')
    user = iam.User(event['username'])
    user.create()
    user.add_group(GroupName='CrossAccountAccess')

    password = generate_password()
    user.create_login_profile(
        Password=password,
        PasswordResetRequired=True
    )
    return password
