using System;
using System.IO;
using System.Security.Cryptography;

public class EncryptionHelper
{
    public static string GenerateEncryptedKey()
    {
        string input = "Key";
        using (Aes aes = Aes.Create())
        {
            aes.GenerateKey();
            aes.GenerateIV();

            ICryptoTransform encryptor = aes.CreateEncryptor(aes.Key, aes.IV);

            using (var ms = new MemoryStream())
            {
                using (var cs = new CryptoStream(ms, encryptor, CryptoStreamMode.Write))
                {
                    using (var sw = new StreamWriter(cs))
                    {
                        sw.Write(input);
                    }
                }

                byte[] encrypted = ms.ToArray();
                return Convert.ToBase64String(encrypted);
            }
        }
    }
}