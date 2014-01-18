signaturecheckButton = nil

function init()
  signaturecheckButton = modules.strmed_interface.addWidget('signaturecheck', 'Print file signatures', '/strmed/images/signaturecheck', printSignatures)
end

function terminate()
  signaturecheckButton:destroy()
end

function printSignatures()
  StrmEd.log('Signatures:')

  if g_sprites.isLoaded() then
    StrmEd.log(string.format('== Spr Signature: %i [ 0x%x ]', g_sprites.getSprSignature(), g_sprites.getSprSignature()))
  else
    StrmEd.log('== No .spr file loaded.')
  end
  if g_things.isDatLoaded() then
    StrmEd.log(string.format('== Dat Signature: %i [ 0x%x ]', g_things.getDatSignature(), g_things.getDatSignature()))
  else
    StrmEd.log('== No .dat file loaded.')
  end
end