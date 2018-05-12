using System;
using System.Collections.Generic;
using System.IO;
using Xunit;

namespace Salaros.Email.Test
{
    public class IsBizMailTest
    {
        [Fact]
        public void IsValid()
        {
            foreach (var businessEmail in EmailSamples.Business)
            {
                var isValid = IsBizMail.IsValid(businessEmail);
                Assert.True(isValid, $"{businessEmail} is not free (business)");
            }

        }

        [Fact]
        public void IsFree()
        {
            foreach (var freeEmail in EmailSamples.Free)
            {
                var isFree = IsBizMail.IsFreeMailAddress(freeEmail);
                Assert.True(isFree, $"{freeEmail} is free");
            }

        }

        [Fact]
        public void HasDomainDefinitions()
        {
            Assert.NotEmpty(IsBizMail.GetFreeDomains());
        }

        private static readonly EmailSamples EmailSamples;

        static IsBizMailTest()
        {
            var sampleEmailsPath = Environment.CurrentDirectory;
            do
            {
                sampleEmailsPath = Directory.GetParent(sampleEmailsPath).FullName;
            } while (!sampleEmailsPath.EndsWith("test"));
            sampleEmailsPath = Path.Combine(sampleEmailsPath, "emailSamples.json");
            var sampleEmailsRaw = File.ReadAllText(sampleEmailsPath);
            EmailSamples = Newtonsoft.Json.JsonConvert.DeserializeObject<EmailSamples>(sampleEmailsRaw);
        }
    }
}
