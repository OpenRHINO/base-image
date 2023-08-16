/*
Copyright 2023 OpenRHINO.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Check if FUNC_NAME is passed as an argument
if [ "$#" -ne 1 ]; then
    echo "Error: Please provide the FUNC_NAME as an argument." >&2
    exit 1
fi

FUNC_NAME="$1"

# Look for executable files named $FUNC_NAME and check uniqueness
file_path=$(find ./ -type f -name "$FUNC_NAME" -executable)
if [ "$file_path" ]; then
    if [ "$(echo "$file_path" | wc -l)" -gt 1 ]; then
        echo "Found multiple executable files named '$FUNC_NAME'. Please check your Makefile!" >&2
        exit 1 
    fi
    if [ ! -d "/app" ]; then
        mkdir "/app"
    fi
    cp "$file_path" "/app/$FUNC_NAME"
    echo "Loading app $FUNC_NAME"
else
# Exit and report an err when no $FUNC_NAME file is found
    echo "Cannot find file $FUNC_NAME!" >&2
    exit 1
fi

# if [ ! -d "/shared_lib" ]; then
#     mkdir "/shared_lib"
# fi
# cd "/shared_lib"
# echo "The shared_lib dir created"

mkdir -p 3rdParty/libs/
mkdir -p 3rdParty/mpiexec/

cp /usr/bin/mpiexec.hydra 3rdParty/mpiexec/
cp /usr/bin/hydra_pmi_proxy 3rdParty/mpiexec/

# Function to recursively copy dependencies
copy_dependencies() {
    local binary_path=$1
    local dest_folder=$2
    local temp_file=$3

    echo "binary_path: ${binary_path}"
    local ldd_output
    ldd_output="$(ldd "${binary_path}" | grep '=>' | awk '{print $3}' | grep -v 'not found' || true)"

    if [ -z "${ldd_output}" ]; then
        return
    fi

    echo "${ldd_output}" | while read -r lib_path; do
        # Check if the library has already been copied
        echo "lib_path: ${lib_path}"
        if ! grep -q "^${lib_path}$" "${temp_file}"; then
            echo "${lib_path}" >> "${temp_file}"
            echo "Copying ${lib_path} to ${dest_folder} ..."
            cp "${lib_path}" "${dest_folder}"

            # Recursively copy the dependencies of the library
            copy_dependencies "${lib_path}" "${dest_folder}" "${temp_file}"
        fi
    done
}

# A temporary file to store the library paths
temp_file="$(mktemp)"
echo "temp_file: ${temp_file}"
# Call the function to copy dependencies
copy_dependencies "/app/$FUNC_NAME" "3rdParty/libs/" "${temp_file}"

# Clean up the temporary file
rm "${temp_file}"

echo "ldd analysis success!"