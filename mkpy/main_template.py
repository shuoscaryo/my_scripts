# ============================================================
# Base template for Python scripts.
#
# Usage:
# - Can be executed directly as a script (`python myscript.py`)
# - Or imported as a module to reuse its functions.
#
# Conventions:
# - Functions and variables starting with "_" are considered internal
#   and should not be imported/used directly.
# ============================================================

import argparse
import logging


def _main(args: argparse.Namespace) -> int:
    """
    Entry point of the program. Args can be modified in 'parse_args()'.

    Args:
    - args (argparse.Namespace): Arguments parsed from the command line.
        Accesible by key 'args.name'. A key can be modified args.name= 'hello'

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

    ### WRITE ARGS HERE
    # - Positional
    # parser.add_argument("name", type = str, help = "")
    # - Optional
    # -- Flag
    # parser.add_argument('-s', '--skip-gaps', action='store_true', help="")
    # -- With content "--output file.txt"
    # parser.add_argument('-o', '--output', type = str, help = "")
    ### NO MORE ARGS BELOW THIS

    args = parser.parse_args()
    return args


def _setup_logging(level_index: int) -> None:
    """
    Handles what level to show and the format of the messages while logging.

    Args:
    - level_index (int): Number between 0 and 4 that sets the level of logging
        0 is to log from DEBUG up to 4 which is only log CRITICAL

    Returns:
    - None

    Raises:
    - ValueError: if "level_index" is out of range.
    """
    if not 0 <= level_index <= 4:
        raise ValueError("level_index must be between 0 and 4")
    LEVELS = [
        logging.DEBUG,     # 0
        logging.INFO,      # 1
        logging.WARNING,   # 2
        logging.ERROR,     # 3
        logging.CRITICAL,  # 4
    ]
    logging.basicConfig(
        level=LEVELS[level_index],
        format="%(asctime)s %(module)s:%(lineno)d | %(levelname)s %(message)s",
        datefmt="%H:%M:%S",
        force=True,
    )


if __name__ == "__main__":
    args = _parse_args()
    _setup_logging(args.log_level)
    result = _main(args)
    raise SystemExit(result) # exit code from main to CLI