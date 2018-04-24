import boto3
import click
import logging
import string
from secrets import choice
from notifications_python_client.notifications import NotificationsAPIClient



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
@click.option('--notify-api-key', envvar='NOTIFY_API_KEY')
def create_user(email, notify_api_key):
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
    if notify_api_key:
        notifications_client = NotificationsAPIClient(notify_api_key)
        logger.warn('Emailing user with Notify')
        response = notifications_client.send_email_notification(
            email_address=email,
            template_id='4887fdf1-0b0b-4cb2-883f-907f4f12b346',
            personalisation={
                'first_name': email.split('.')[0].capitalize(),
                'username': email,
                'password': password,
            }
        )
        logger.warn('Notify Reference: {}'.format(response['id']))
    else:
        click.echo(password)

if __name__ == '__main__':
    create_user()
