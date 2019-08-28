package org.ergoplatform.nodeView.history.storage.modifierprocessors.popow

import org.ergoplatform.modifiers.ErgoPersistentModifier
import org.ergoplatform.modifiers.history.{HeaderChain, PoPowProof}
import org.ergoplatform.nodeView.history.storage.modifierprocessors.HeadersProcessor
import scorex.core.consensus.History.ProgressInfo
import scorex.util.ScorexLogging

import scala.util.Try

/**
  * Contains all functions required by History to process PoPoWProofs and generate them.
  */
trait PoPoWProofsProcessor extends HeadersProcessor with ScorexLogging {

  def validate(m: PoPowProof): Try[Unit]

  def process(m: PoPowProof): ProgressInfo[ErgoPersistentModifier]

  def lastHeaders(count: Int, offset: Int = 0): HeaderChain
}
