import logging
from typing import Any, Dict, List, Optional
import resend
from gqlapi.config import RESEND_API_KEY, SENDGRID_SINGLE_SENDER


async def send_email(
    email_to: str,
    subject: str,
    content: str,
    from_email: Dict[str, str] = {"email": SENDGRID_SINGLE_SENDER, "name": "Alima"},
) -> bool:
    """Send Email

    Returns
    -------
    Bool
        True if correctly sent
    """
    #
    resend.api_key = RESEND_API_KEY
    params: resend.Emails.SendParams = {
        "from": SENDGRID_SINGLE_SENDER,
        "to": [email_to],
        "subject": subject,
        "html": content,
    }
    try:
        email = resend.Emails.send(params)
        print(email)
        return True
    except Exception as e:
        logging.info(e)
        return False


def send_email_with_attachments_syncronous(
    email_to: str | List[str], subject: str, content: str, attchs: List[Dict[str, Any]], sender_name: Optional[str] = "Alima"
) -> bool:
    """Send Email with attachments

    Returns
    -------
    Bool
        True if correctly sent
    """
    resend.api_key = RESEND_API_KEY
    params: resend.Emails.SendParams = {
        "from": SENDGRID_SINGLE_SENDER,
        "to": [email_to],
        "subject": subject,
        "html": content,
        "attachments": attchs
    }

    try:
        email = resend.Emails.send(params)
        print(email)
        return True
    except Exception as e:
        logging.info(e)
        return False
