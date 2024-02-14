import os
import shutil

def convert_lua_to_txt(file_path, output_folder):
    with open(file_path, 'r') as lua_file:
        lua_content = lua_file.read()
    
    # Create the output folder if it doesn't exist
    os.makedirs(output_folder, exist_ok=True)

    txt_file_path = os.path.join(output_folder, os.path.basename(file_path).replace('.lua', '.txt'))

    with open(txt_file_path, 'w') as txt_file:
        txt_file.write(lua_content)

def convert_lua_files_in_directory(directory, output_folder):
    # Delete all files in the output folder before conversion
    if os.path.exists(output_folder):
        shutil.rmtree(output_folder)
    
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.lua'):
                file_path = os.path.join(root, file)
                convert_lua_to_txt(file_path, output_folder)
                print(f"Converted {file_path} to text.")

if __name__ == "__main__":
    current_directory = os.getcwd()
    output_directory = os.path.join(current_directory, "txtfiles")
    convert_lua_files_in_directory(current_directory, output_directory)
