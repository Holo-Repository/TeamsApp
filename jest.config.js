module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'jsdom',
  roots: ['<rootDir>'],
  transform: {
    '^.+\\.tsx?$': 'ts-jest'
  },
  testRegex: '(/__tests__/.*|(\\.|/)(test|spec))\\.tsx?$',
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node'],
  setupFilesAfterEnv: ['<rootDir>/jest-setup.ts'],
  moduleNameMapper: {"\\.(css|less|sass|scss)$": "<rootDir>/styleMock.js",
  "\\.(gif|ttf|eot|svg)$": "<rootDir>/fileMock.js"},
};
