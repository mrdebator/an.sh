# main.py

import os
import email
from email import policy
from email.parser import BytesParser

# --- Configuration ---
# Set the name of the folder where your .eml files are located.
# This folder must be in the same directory as the script.
input_folder = 'input_eml'

# Set the name of the folder where the converted .txt files will be saved.
# This folder will be created if it doesn't exist.
output_folder = 'output_txt'
# --- End of Configuration ---

def get_email_body(msg):
    """
    This function extracts the plain text body from an email message object.
    It prioritizes plain text parts over HTML.
    """
    body = ""
    if msg.is_multipart():
        # If the email has multiple parts, iterate through them
        for part in msg.walk():
            content_type = part.get_content_type()
            content_disposition = str(part.get('Content-Disposition'))

            # Look for the plain text part and ignore attachments
            if content_type == 'text/plain' and 'attachment' not in content_disposition:
                # Decode the payload and add it to our body
                payload = part.get_payload(decode=True)
                try:
                    body += payload.decode('utf-8')
                except UnicodeDecodeError:
                    # Fallback to another encoding if utf-8 fails
                    body += payload.decode('latin-1')
    else:
        # If the email is not multipart, it's a simple email
        payload = msg.get_payload(decode=True)
        try:
            body = payload.decode('utf-8')
        except UnicodeDecodeError:
            body = payload.decode('latin-1')
            
    return body

def main():
    """
    Main function to run the conversion process.
    """
    print("Starting EML to TXT conversion...")

    # Create the output directory if it doesn't exist
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
        print(f"Created output folder: '{output_folder}'")

    # Get the list of .eml files from the input folder
    try:
        eml_files = [f for f in os.listdir(input_folder) if f.endswith('.eml')]
    except FileNotFoundError:
        print(f"Error: Input folder '{input_folder}' not found.")
        print("Please make sure it exists in the same directory as the script.")
        return

    if not eml_files:
        print(f"No .eml files found in '{input_folder}'.")
        return

    # Process each .eml file
    for filename in eml_files:
        input_path = os.path.join(input_folder, filename)
        
        # Create a new filename with a .txt extension
        base_name = os.path.splitext(filename)[0]
        output_path = os.path.join(output_folder, f"{base_name}.txt")

        print(f"Processing '{filename}' -> '{base_name}.txt'")

        # Open and parse the .eml file
        with open(input_path, 'rb') as f:
            msg = BytesParser(policy=policy.default).parse(f)
        
        # Extract the body text from the email
        body_text = get_email_body(msg)

        # Write the extracted text to the new .txt file
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(body_text)

    print(f"\nConversion complete! {len(eml_files)} files were converted.")
    print(f"Your new .txt files are in the '{output_folder}' folder.")


# This ensures the main function runs when the script is executed
if __name__ == "__main__":
    main()
