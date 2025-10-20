# =============================================================================
#
# To know what this script does or what options it has use the flag "-h":
#     python3 myscript.py -h (it may not be python3 for you)
# Or just scroll to "parse_args" function and read the description.
#
# Template structure:
#   _main()          → The program starts from here
#   _parse_args()    → Arguments and explanation go here.
#   _setup_logging() → configures logging detail and message format (usually no
#     need to touch it)
#
# Conventions:
#   - Functions and variables starting with "_" are internal and should not be
#       imported elsewhere.
#   - Specify function args type and return type.
#   - Double enter between functions.
#   - Try to keep lines below 80 characters, wrap long ones into multiple
#       lines.
#   - Use this docstring to document new functions:
#       """
#       Description saying what the function does.
#       
#       Args:
#       - name (type) (optional): Description
#           More Lines
#       
#       Returns:
#       - type: Description
#           More Lines
#       
#       Raises:
#       - type: Description
#           More Lines
#       """
#   - _main() should return an integer exit code (0 = success) (default = 0).
#
# =============================================================================

import argparse
import logging
import sys

# =============================================================================
# MORE IMPORTS HERE

# =============================================================================


def _main(args: argparse.Namespace) -> int:
    """
    Entry point of the program. Args can be modified in 'parse_args()'.

    Args:
    - args (argparse.Namespace): Arguments parsed from the command line.
        Accesible by key 'args.example'. A key can be modified.
        eg. args.name = 'hello'

    Returns:
    - int: Exit code (0 = success, other values = error).
    """
    return 0


def _parse_args() -> argparse.Namespace:
    """
    This is the function used to configure what args the program has. Write the
    new args as in the examples below.
    Converts the arguments passed to the script into a variable. The variable
    stores each element in a key with the name defined inside the function.
    To access each key is "args.keyName".

    Args:
    - None

    Returns:
    - argparse.Namespace: object containing the keys of the program arguments

    Raises:
    - SystemExit: If there is an issue in the parsing. Prints help and closes
        the program. Can be caught with except but for what reason!
    """
    parser = argparse.ArgumentParser(
        description = "",
        formatter_class = argparse.ArgumentDefaultsHelpFormatter,
        epilog = "Example:",
    )
    # Default flag for setting how deep the logs should go
    parser.add_argument(
        "--log-level",
        type = int,
        choices = range(0,5),
        default = 1,
        metavar = "{0..4}",
        help = "0 = DEBUG, 1 = INFO, 2 = WARNING, 3 = ERROR, 4 = CRITICAL",
    )
    # Default flag to redirect log messages to a file
    parser.add_argument(
        "--log-file",
        type = str,
        default = None,
        help = "Where the logs will be printed (default = stderr)",
    )

    # =========================================================================
    # WRITE ARGS HERE
    # - Positional
    # parser.add_argument("name", type = str, help = "")
    # - Optional
    # -- Flag
    # parser.add_argument('-s', '--skip-gaps', action='store_true', help="")
    # -- With content "--output file.txt"
    # parser.add_argument('-o', '--output', type = str, help = "")
    ### NO MORE ARGS BELOW THIS
    # =========================================================================

    args = parser.parse_args()
    return args


def _setup_logging(args: argparse.Namespace) -> None:
    """
    Handles what level to show and the format of the messages while logging.

    Args:
    - args (argparse.Namespace): Arguments parsed from the command line.
        Expected attributes:
            - log_level (int): 0 (DEBUG) to 4 (CRITICAL)
            - log_file (str or None) (optional): path to a log file

    Returns:
    - None

    Raises:
    - ValueError: if "level_index" is out of range.
    """
    if not 0 <= args.log_level <= 4:
        raise ValueError("--log-level must be between 0 and 4")
    LEVELS = [
        logging.DEBUG,     # 0
        logging.INFO,      # 1
        logging.WARNING,   # 2
        logging.ERROR,     # 3
        logging.CRITICAL,  # 4
    ]

    handlers = []
    if args.log_file:
        handlers.append(logging.FileHandler(args.log_file, mode="w"))
    else:
        handlers.append(logging.StreamHandler(sys.stderr))

    logging.basicConfig(
        level=LEVELS[args.log_level],
        format="%(asctime)s %(levelname)s | %(filename)s:%(lineno)d: %(message)s",
        datefmt="%H:%M:%S",
        handlers=handlers,
        force=True,
    )


if __name__ == "__main__":
    args = _parse_args()
    _setup_logging(args)
    result = _main(args)
    if not isinstance(result, int):
        logging.warning(
            f"_main() returned {type(result).__name__}, expected int. "
            "Using exit code 0."
        )
        result = 0
    raise SystemExit(result) # exit code from main to CLI