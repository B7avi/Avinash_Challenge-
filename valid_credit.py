import re

card_num_regex = re.compile(r'^([456]\d{3}-?\d{4}-?\d{4}-?\d{4})$')


def is_valid(card_num: str):
    if not card_num_regex.match(card_num):
        return False

    last_digit = ''
    last_digit_count = 1
    for letter in card_num:
        if not letter.isdigit():
            continue

        if letter == last_digit:
            last_digit_count += 1
        else:
            last_digit_count = 1
            last_digit = letter

        if last_digit_count >= 4:
            return False

    return True


if __name__ == '__main__':
    n = int(input())

    for _ in range(n):
        if is_valid(input()):
            print('Valid')
        else:
            print('Invalid')