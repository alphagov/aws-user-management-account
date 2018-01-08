import boto3
import click
import logging
import string
from secrets import choice


logger = logging.getLogger()
# We're leaving this as WARN rather than INFO because boto logs all API calls
# with all params, which means we'd be logging the password.
logger.setLevel(logging.WARN)


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


@click.command()
@click.argument('email')
def create_user(email):
    '''Create a user with permission to assume roles and manage their credentials.
    We'd like to send them an email with instructions to get set up and send
    their password via another contact method too, but for now return it.
    '''
    username = email
    logger.warn('create_user called with username {}'.format(username))

    iam = boto3.resource('iam')
    user = iam.User(username)
    user.create()
    user.add_group(GroupName='CrossAccountAccess')

    password = generate_password()
    user.create_login_profile(
        Password=password,
        PasswordResetRequired=True
    )
    click.echo(password)

if __name__ == '__main__':
    create_user()
