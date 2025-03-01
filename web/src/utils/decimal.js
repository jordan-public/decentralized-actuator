import BigNumber from 'bignumber.js';

/**
 * Converts a BigInt value to a decimal number string.
 * 
 * @param {BigInt} bigIntValue - The BigInt value to convert.
 * @returns {string} - The decimal number string.
 */
export function bigIntToDecimal(bigIntValue) {
    // Create a BigNumber from the BigInt
    let bigNumberValue = new BigNumber(bigIntValue.toString());

    // Divide by 10^18
    let result = bigNumberValue.dividedBy(new BigNumber(10).pow(18));

    // Format the result as a decimal string
    return result.toFixed();
}

/**
 * Converts a decimal number string to a BigInt value by multiplying by 10^18.
 * 
 * @param {string} decimalValue - The decimal number string to convert.
 * @returns {BigInt} - The resulting BigInt value.
 */
export function decimalToBigInt(decimalValue) {
    // Create a BigNumber from the decimal value
    let bigNumberValue = new BigNumber(decimalValue);

    // Multiply by 10^18
    let result = bigNumberValue.multipliedBy(new BigNumber(10).pow(18));

    // Convert to BigInt
    return BigInt(result.toFixed());
}