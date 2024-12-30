#!/bin/bash

sleep 1

if [ "$1" != "--help" ] && [ "$1" != "-h" ]; then # I got kinda fucked near the end and
    if [ -z "$1" ]; then                          # used this as a sorta workaround
        echo -e "\nRunError: cpp-file is required."
        echo -e "Consider running \"cpp --help\".\n"
    else

        FILE=$(realpath "$1")
        shift

        OUTPUT_LOCATION="$PWD/build/product"
        RUN_AFTER="FALSE"
        USING_DEFAULT_OUTPUT="TRUE"
        NEED_HELP="FALSE"

        while [ $# -gt 0 ]; do # Establish and get Command-line args
            case "$1" in
            --output)
                OUTPUT_LOCATION=$(realpath "$2")
                USING_DEFAULT_OUTPUT="FALSE"
                shift 2
                ;;
            -o)
                OUTPUT_LOCATION=$(realpath "$2")
                shift 2
                ;;
            --run)
                RUN_AFTER="TRUE"
                shift
                ;;
            -r)
                RUN_AFTER="TRUE"
                shift
                ;;
            --help)
                NEED_HELP="TRUE"
                shift
                ;;
            -h)
                NEED_HELP="TRUE"
                shift
                ;;
            esac
        done

        if [ "$NEED_HELP" == "TRUE" ]; then # If --help is added then dont run and instead print the manual

            cat ~/.cppCompile/man.txt

        else

            # If --help isn't added then run normally

            echo -e "\nfile: $FILE"
            echo -e "output: $OUTPUT_LOCATION\n"

            START_TIME=$(date +%s)

            if [ "$USING_DEFAULT_OUTPUT" == "TRUE" ]; then
                if [ -d "$(pwd)/build" ]; then
                    :
                else
                    echo -e "BuildDirectory not found: Creating one. $(pwd)/build\n"
                    mkdir "$(pwd)/build"
                fi
            fi

            g++ $FILE -o $OUTPUT_LOCATION
            
            COMPILE_STATUS=$?

            END_TIME=$(date +%s)

            sleep 1

            COLS=$(tput cols)

            DIVIDER=$(printf '%*s' "$COLS" | tr ' ' '*')

            ELAPSED=$((END_TIME - START_TIME))

            if [ "$COMPILE_STATUS" -eq 0 ]; then
                echo "Compilation successful! ;3 (elapsed: $ELAPSED)"

                if [ "$RUN_AFTER" == "TRUE" ]; then # Check if user wants to run it after.
                    echo -e "Running...\n"
                    sleep 1
                    echo "Beyond this point will be your code."
                    echo -e "$DIVIDER\n"

                    sleep 1
                    "$OUTPUT_LOCATION" # Run the compiled project.
                else
                    echo ""
                fi
            else
                echo "Compilation failed...\n"
            fi
        fi
    fi
else
    cat ~/.cppCompile/man.txt
    echo ""
fi
